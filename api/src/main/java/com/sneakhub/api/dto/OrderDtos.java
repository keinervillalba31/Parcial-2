package com.sneakhub.api.dto;

import com.sneakhub.api.entity.Order;
import com.sneakhub.api.entity.OrderItem;
import com.sneakhub.api.entity.OrderStatus;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;
import java.util.List;

/** Pedidos (compras). */
public final class OrderDtos {

    private OrderDtos() {
    }

    public record OrderItemRequest(
            @NotNull(message = "El tenis es obligatorio") Long sneakerId,
            @NotNull(message = "La talla es obligatoria") Integer size,
            @NotNull(message = "La cantidad es obligatoria") @Min(value = 1, message = "Cantidad mínima 1") Integer quantity) {
    }

    public record OrderRequest(
            @NotEmpty(message = "El pedido debe tener al menos un producto")
            List<@Valid OrderItemRequest> items) {
    }

    public record StatusRequest(@NotNull(message = "El estado es obligatorio") OrderStatus status) {
    }

    public record OrderItemResponse(
            Long id,
            Long sneakerId,
            String sneakerName,
            String image,
            Integer size,
            Integer quantity,
            Double unitPrice,
            Double subtotal) {

        public static OrderItemResponse from(OrderItem item) {
            var sneaker = item.getSneaker();
            var image = sneaker.getImages().isEmpty() ? null : sneaker.getImages().get(0);
            return new OrderItemResponse(
                    item.getId(),
                    sneaker.getId(),
                    sneaker.getName(),
                    image,
                    item.getSize(),
                    item.getQuantity(),
                    item.getUnitPrice(),
                    item.getUnitPrice() * item.getQuantity());
        }
    }

    public record OrderResponse(
            Long id,
            UserResponse user,
            List<OrderItemResponse> items,
            Double total,
            OrderStatus status,
            LocalDateTime createdAt) {

        public static OrderResponse from(Order order) {
            return new OrderResponse(
                    order.getId(),
                    UserResponse.from(order.getUser()),
                    order.getItems().stream().map(OrderItemResponse::from).toList(),
                    order.getTotal(),
                    order.getStatus(),
                    order.getCreatedAt());
        }
    }
}
