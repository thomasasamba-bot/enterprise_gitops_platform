package com.example.product;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.Arrays;

@SpringBootApplication
@RestController
public class ProductApplication {

    public static void main(String[] args) {
        SpringApplication.run(ProductApplication.class, args);
    }

    @GetMapping("/products")
    public List<String> getProducts() {
        return Arrays.asList("Laptop", "Phone", "Tablet");
    }

    @GetMapping("/health")
    public String health() {
        return "{\"status\": \"UP\", \"service\": \"product-service\"}";
    }
}
