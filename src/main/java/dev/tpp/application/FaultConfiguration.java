package dev.tpp.application;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration(proxyBeanMethods = false)
public class FaultConfiguration {
  @Bean
  @ConditionalOnMissingBean(TransferFaults.class)
  TransferFaults transferFaults() {
    return boundary -> {};
  }
}
