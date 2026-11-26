package dev.tpp;

import com.jayway.jsonpath.JsonPath;
import java.net.ServerSocket;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.NewTopic;
import org.apache.kafka.clients.admin.OffsetSpec;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.serialization.ByteArrayDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.testcontainers.kafka.KafkaContainer;

/**
 * Independent Kafka clients inspect broker records and offsets; they never call application code.
 */
final class KafkaTestSupport implements AutoCloseable {
  final KafkaContainer broker = new KafkaContainer(TestImages.kafka()).withImagePullPolicy(image -> false);
  private AdminClient admin;

  void start() {
    try (ServerSocket available = new ServerSocket(0)) {
      // Docker's dynamic host binding is reallocated on stop/start. A reserved free port in the
      // explicit HostConfig remains stable, matching Kafka's advertised listener after restart.
      broker.setPortBindings(List.of("127.0.0.1:" + available.getLocalPort() + ":9092"));
    } catch (java.io.IOException failure) {
      throw new IllegalStateException("Cannot allocate a local Kafka test port", failure);
    }
    broker.start();
    admin =
        AdminClient.create(Map.of("bootstrap.servers", bootstrap(), "request.timeout.ms", 2000));
  }

  String bootstrap() {
    return broker.getBootstrapServers();
  }

  void createTopic(String topic) throws Exception {
    createTopic(topic, 1);
  }

  void createTopic(String topic, int partitions) throws Exception {
    admin
        .createTopics(List.of(new NewTopic(topic, partitions, (short) 1)))
        .all()
        .get(15, TimeUnit.SECONDS);
  }

  void stopBroker() {
    // Testcontainers.stop() removes the container and changes its next advertised port. Stop/start
    // this exact suite-owned Docker container instead, preserving its log and mapped port.
    broker.getDockerClient().stopContainerCmd(broker.getContainerId()).withTimeout(2).exec();
  }

  void pauseBroker() {
    broker.getDockerClient().pauseContainerCmd(broker.getContainerId()).exec();
  }

  void unpauseBroker() {
    // A pause/unpause response can be lost after Docker applies it. Inspect this exact owned
    // container so finally/AfterEach restoration is safe both before and after an uncertain call.
    var state = broker.getDockerClient().inspectContainerCmd(broker.getContainerId()).exec().getState();
    if (Boolean.TRUE.equals(state.getPaused()))
      broker.getDockerClient().unpauseContainerCmd(broker.getContainerId()).exec();
  }

  void restartBroker() throws Exception {
    broker.getDockerClient().startContainerCmd(broker.getContainerId()).exec();
    await(
        "Kafka broker restart",
        Duration.ofSeconds(30),
        () -> {
          try {
            admin.listTopics().names().get(2, TimeUnit.SECONDS);
            return true;
          } catch (Exception unavailable) {
            return false;
          }
        });
  }

  RecordMetadata publish(String topic, String key, String payload) throws Exception {
    try (KafkaProducer<String, String> producer = new KafkaProducer<>(producerSettings())) {
      return producer.send(new ProducerRecord<>(topic, key, payload)).get(15, TimeUnit.SECONDS);
    }
  }

  /** Real asynchronous sends return individual acknowledgements in input order for assertions. */
  List<RecordMetadata> publishBatch(List<ProducerRecord<String, String>> records) throws Exception {
    if (records.isEmpty() || records.size() > 1024)
      throw new IllegalArgumentException("Invalid bounded evidence batch");
    try (KafkaProducer<String, String> producer = new KafkaProducer<>(producerSettings())) {
      List<CompletableFuture<RecordMetadata>> outcomes = new ArrayList<>(records.size());
      for (var record : records) {
        var outcome = new CompletableFuture<RecordMetadata>();
        outcomes.add(outcome);
        producer.send(
            record,
            (metadata, error) -> {
              if (error == null) outcome.complete(metadata);
              else outcome.completeExceptionally(error);
            });
      }
      CompletableFuture.allOf(outcomes.toArray(CompletableFuture<?>[]::new))
          .get(15, TimeUnit.SECONDS);
      return outcomes.stream().map(CompletableFuture::join).toList();
    }
  }

  private Properties producerSettings() {
    Properties settings = new Properties();
    settings.put("bootstrap.servers", bootstrap());
    settings.put("acks", "all");
    settings.put("enable.idempotence", "true");
    settings.put("key.serializer", StringSerializer.class.getName());
    settings.put("value.serializer", StringSerializer.class.getName());
    settings.put("delivery.timeout.ms", "10000");
    settings.put("request.timeout.ms", "3000");
    return settings;
  }

  List<ConsumerRecord<String, byte[]>> records(String topic, UUID eventId, int minimum)
      throws Exception {
    return recordsFor(topic, Set.of(eventId), minimum);
  }

  List<ConsumerRecord<String, byte[]>> recordsFor(String topic, Set<UUID> eventIds, int minimum)
      throws Exception {
    Properties settings = new Properties();
    settings.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrap());
    settings.put(ConsumerConfig.GROUP_ID_CONFIG, "evidence-" + UUID.randomUUID());
    settings.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, false);
    settings.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    settings.put(
        ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class.getName());
    var selected = new ArrayList<ConsumerRecord<String, byte[]>>();
    try (KafkaConsumer<String, byte[]> evidence = new KafkaConsumer<>(settings)) {
      var partitions = partitions(topic);
      evidence.assign(partitions);
      evidence.seekToBeginning(partitions);
      long deadline = System.nanoTime() + TimeUnit.SECONDS.toNanos(15);
      while (System.nanoTime() < deadline) {
        for (var record : evidence.poll(Duration.ofMillis(100))) {
          try {
            String identity =
                JsonPath.read(
                    new String(record.value(), java.nio.charset.StandardCharsets.UTF_8),
                    "$.eventId");
            if (eventIds.contains(UUID.fromString(identity))) selected.add(record);
          } catch (RuntimeException malformed) {
            // Malformed poison records have no readable UUID; a separate test inspects quarantine.
          }
        }
        if (selected.size() >= minimum) return List.copyOf(selected);
      }
    }
    throw new AssertionError(
        "Kafka contained "
            + selected.size()
            + " records for "
            + eventIds
            + "; expected at least "
            + minimum);
  }

  long committedOffset(String group, String topic) throws Exception {
    var offsets =
        admin
            .listConsumerGroupOffsets(group)
            .partitionsToOffsetAndMetadata()
            .get(5, TimeUnit.SECONDS);
    var value = offsets.get(new TopicPartition(topic, 0));
    return value == null ? -1 : value.offset();
  }

  Map<TopicPartition, Long> committedOffsets(String group, String topic) throws Exception {
    var offsets =
        admin
            .listConsumerGroupOffsets(group)
            .partitionsToOffsetAndMetadata()
            .get(5, TimeUnit.SECONDS);
    var selected = new java.util.HashMap<TopicPartition, Long>();
    for (var partition : partitions(topic)) {
      var offset = offsets.get(partition);
      selected.put(partition, offset == null ? -1 : offset.offset());
    }
    return Map.copyOf(selected);
  }

  private List<TopicPartition> partitions(String topic) throws Exception {
    return admin
        .describeTopics(List.of(topic))
        .allTopicNames()
        .get(5, TimeUnit.SECONDS)
        .get(topic)
        .partitions()
        .stream()
        .map(partition -> new TopicPartition(topic, partition.partition()))
        .toList();
  }

  long endOffset(String topic) throws Exception {
    TopicPartition partition = new TopicPartition(topic, 0);
    return admin
        .listOffsets(Map.of(partition, OffsetSpec.latest()))
        .all()
        .get(5, TimeUnit.SECONDS)
        .get(partition)
        .offset();
  }

  int groupMembers(String group) throws Exception {
    return admin
        .describeConsumerGroups(List.of(group))
        .all()
        .get(5, TimeUnit.SECONDS)
        .get(group)
        .members()
        .size();
  }

  static void await(String description, Duration timeout, Callable<Boolean> condition)
      throws Exception {
    long deadline = System.nanoTime() + timeout.toNanos();
    while (System.nanoTime() < deadline) {
      if (condition.call()) return;
      Thread.sleep(25);
    }
    throw new AssertionError("Timed out waiting for " + description);
  }

  @Override
  public void close() {
    if (admin != null) admin.close(Duration.ofSeconds(3));
    broker.stop();
  }
}
