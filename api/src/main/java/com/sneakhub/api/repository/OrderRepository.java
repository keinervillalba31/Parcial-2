package com.sneakhub.api.repository;

import com.sneakhub.api.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByUserEmailOrderByCreatedAtDesc(String email);

    List<Order> findAllByOrderByCreatedAtDesc();
}
