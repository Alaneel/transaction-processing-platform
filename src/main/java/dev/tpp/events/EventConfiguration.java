package dev.tpp.events;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration(proxyBeanMethods = false)
@EnableScheduling
public class EventConfiguration {
  @Bean
  @ConditionalOnMissingBean(EventFaults.class)
  EventFaults eventFaults() {
    return (boundary, id) -> {};
  }
}
