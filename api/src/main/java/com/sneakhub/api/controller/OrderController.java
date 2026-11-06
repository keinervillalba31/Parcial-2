package com.sneakhub.api.controller;

import com.sneakhub.api.dto.OrderDtos.OrderRequest;
import com.sneakhub.api.dto.OrderDtos.OrderResponse;
import com.sneakhub.api.dto.OrderDtos.StatusRequest;
import com.sneakhub.api.service.OrderService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public OrderResponse create(Authentication auth, @Valid @RequestBody OrderRequest request) {
        return orderService.create(auth.getName(), request);
    }

    @GetMapping
    public List<OrderResponse> findAll(Authentication auth) {
        return orderService.findAll(auth.getName(), isAdmin(auth));
    }

    @GetMapping("/{id}")
    public OrderResponse findById(Authentication auth, @PathVariable Long id) {
        return orderService.findById(id, auth.getName(), isAdmin(auth));
    }

    /** Solo ADMIN (ver SecurityConfig). */
    @PatchMapping("/{id}/status")
    public OrderResponse updateStatus(@PathVariable Long id, @Valid @RequestBody StatusRequest request) {
        return orderService.updateStatus(id, request.status());
    }

    private boolean isAdmin(Authentication auth) {
        return auth.getAuthorities().stream().anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
    }
}
