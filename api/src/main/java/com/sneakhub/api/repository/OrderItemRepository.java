package com.sneakhub.api.repository;

import com.sneakhub.api.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

    boolean existsBySneakerId(Long sneakerId);
}
