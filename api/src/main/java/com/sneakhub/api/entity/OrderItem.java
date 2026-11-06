package com.sneakhub.api.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "order_items")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "order_id")
    private Order order;

    @ManyToOne(optional = false)
    @JoinColumn(name = "sneaker_id")
    private Sneaker sneaker;

    @Column(nullable = false)
    private Integer size;

    @Column(nullable = false)
    private Integer quantity;

    /** Precio al momento de la compra (si luego cambia el precio del tenis, el pedido no cambia). */
    @Column(nullable = false)
    private Double unitPrice;

    protected OrderItem() {
    }

    public OrderItem(Sneaker sneaker, Integer size, Integer quantity) {
        this.sneaker = sneaker;
        this.size = size;
        this.quantity = quantity;
        this.unitPrice = sneaker.getPrice();
    }

    public Long getId() { return id; }
    public Order getOrder() { return order; }
    void setOrder(Order order) { this.order = order; }
    public Sneaker getSneaker() { return sneaker; }
    public Integer getSize() { return size; }
    public Integer getQuantity() { return quantity; }
    public Double getUnitPrice() { return unitPrice; }
}
