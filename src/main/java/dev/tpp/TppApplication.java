package dev.tpp;

import dev.tpp.application.BackpressureSettings;
import dev.tpp.application.TransferSettings;
import dev.tpp.events.EventSettings;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties({
  TransferSettings.class,
  EventSettings.class,
  BackpressureSettings.class
})
public class TppApplication {
  public static void main(String[] args) {
    SpringApplication.run(TppApplication.class, args);
  }
}
