package com.sneakhub.api.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "sneakers")
public class Sneaker {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(nullable = false)
    private Double price;

    @Column(nullable = false)
    private Integer stock;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Gender gender;

    private String colors;

    /** Tallas disponibles (ej: 38, 39, 40). Se guardan en la tabla sneaker_sizes. */
    @ElementCollection
    @CollectionTable(name = "sneaker_sizes", joinColumns = @JoinColumn(name = "sneaker_id"))
    @Column(name = "size")
    private List<Integer> sizes = new ArrayList<>();

    /** URLs de las imágenes. Se guardan en la tabla sneaker_images. */
    @ElementCollection
    @CollectionTable(name = "sneaker_images", joinColumns = @JoinColumn(name = "sneaker_id"))
    @Column(name = "url", length = 500)
    private List<String> images = new ArrayList<>();

    @ManyToOne(optional = false)
    @JoinColumn(name = "brand_id")
    private Brand brand;

    @ManyToOne(optional = false)
    @JoinColumn(name = "category_id")
    private Category category;

    public Sneaker() {
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }
    public Gender getGender() { return gender; }
    public void setGender(Gender gender) { this.gender = gender; }
    public String getColors() { return colors; }
    public void setColors(String colors) { this.colors = colors; }
    public List<Integer> getSizes() { return sizes; }
    public void setSizes(List<Integer> sizes) { this.sizes = new ArrayList<>(sizes); }
    public List<String> getImages() { return images; }
    public void setImages(List<String> images) { this.images = new ArrayList<>(images); }
    public Brand getBrand() { return brand; }
    public void setBrand(Brand brand) { this.brand = brand; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
}
