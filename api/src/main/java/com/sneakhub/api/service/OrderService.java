package com.sneakhub.api.service;

import com.sneakhub.api.dto.OrderDtos.OrderItemRequest;
import com.sneakhub.api.dto.OrderDtos.OrderRequest;
import com.sneakhub.api.dto.OrderDtos.OrderResponse;
import com.sneakhub.api.entity.*;
import com.sneakhub.api.exception.ApiException;
import com.sneakhub.api.repository.OrderRepository;
import com.sneakhub.api.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class OrderService {

    private final OrderRepository orders;
    private final UserRepository users;
    private final SneakerService sneakerService;

    public OrderService(OrderRepository orders, UserRepository users, SneakerService sneakerService) {
        this.orders = orders;
        this.users = users;
        this.sneakerService = sneakerService;
    }

    /** Crea el pedido, valida talla y stock, y descuenta el stock. */
    @Transactional
    public OrderResponse create(String email, OrderRequest request) {
        User user = users.findByEmail(email).orElseThrow(() -> ApiException.unauthorized("Usuario no encontrado"));
        Order order = new Order(user);

        // Suma las cantidades por tenis para validar contra el stock total.
        Map<Long, Integer> requested = new HashMap<>();
        for (OrderItemRequest item : request.items()) {
            requested.merge(item.sneakerId(), item.quantity(), Integer::sum);
        }

        for (OrderItemRequest item : request.items()) {
            Sneaker sneaker = sneakerService.get(item.sneakerId());
            if (!sneaker.getSizes().contains(item.size())) {
                throw ApiException.badRequest("La talla " + item.size() + " no está disponible para " + sneaker.getName());
            }
            if (requested.get(sneaker.getId()) > sneaker.getStock()) {
                throw ApiException.badRequest("Stock insuficiente para " + sneaker.getName()
                        + " (disponibles: " + sneaker.getStock() + ")");
            }
            order.addItem(new OrderItem(sneaker, item.size(), item.quantity()));
        }

        order.getItems().forEach(i -> i.getSneaker().setStock(i.getSneaker().getStock() - i.getQuantity()));
        return OrderResponse.from(orders.save(order));
    }

    /** El ADMIN ve todos los pedidos; el cliente solo los suyos. */
    @Transactional(readOnly = true)
    public List<OrderResponse> findAll(String email, boolean isAdmin) {
        List<Order> result = isAdmin
                ? orders.findAllByOrderByCreatedAtDesc()
                : orders.findByUserEmailOrderByCreatedAtDesc(email);
        return result.stream().map(OrderResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public OrderResponse findById(Long id, String email, boolean isAdmin) {
        Order order = get(id);
        if (!isAdmin && !order.getUser().getEmail().equals(email)) {
            throw ApiException.forbidden("No puedes ver pedidos de otro usuario");
        }
        return OrderResponse.from(order);
    }

    /** Cambia el estado. Si se cancela, devuelve el stock. */
    @Transactional
    public OrderResponse updateStatus(Long id, OrderStatus status) {
        Order order = get(id);
        if (order.getStatus() == OrderStatus.CANCELADO) {
            throw ApiException.badRequest("El pedido ya está cancelado");
        }
        if (status == OrderStatus.CANCELADO) {
            order.getItems().forEach(i -> i.getSneaker().setStock(i.getSneaker().getStock() + i.getQuantity()));
        }
        order.setStatus(status);
        return OrderResponse.from(order);
    }

    private Order get(Long id) {
        return orders.findById(id).orElseThrow(() -> ApiException.notFound("Pedido " + id + " no encontrado"));
    }
}
