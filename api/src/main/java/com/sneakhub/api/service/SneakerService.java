package com.sneakhub.api.service;

import com.sneakhub.api.dto.SneakerDtos.SneakerRequest;
import com.sneakhub.api.dto.SneakerDtos.SneakerResponse;
import com.sneakhub.api.entity.Gender;
import com.sneakhub.api.entity.Sneaker;
import com.sneakhub.api.exception.ApiException;
import com.sneakhub.api.repository.OrderItemRepository;
import com.sneakhub.api.repository.SneakerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SneakerService {

    private final SneakerRepository sneakers;
    private final OrderItemRepository orderItems;
    private final CatalogService catalog;

    public SneakerService(SneakerRepository sneakers, OrderItemRepository orderItems, CatalogService catalog) {
        this.sneakers = sneakers;
        this.orderItems = orderItems;
        this.catalog = catalog;
    }

    @Transactional(readOnly = true)
    public List<SneakerResponse> findAll(Long brandId, Long categoryId, Gender gender, String q) {
        String search = q == null || q.isBlank() ? null : q.trim();
        return sneakers.search(brandId, categoryId, gender, search).stream()
                .map(SneakerResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public SneakerResponse findById(Long id) {
        return SneakerResponse.from(get(id));
    }

    @Transactional
    public SneakerResponse create(SneakerRequest request) {
        Sneaker sneaker = new Sneaker();
        apply(sneaker, request);
        return SneakerResponse.from(sneakers.save(sneaker));
    }

    @Transactional
    public SneakerResponse update(Long id, SneakerRequest request) {
        Sneaker sneaker = get(id);
        apply(sneaker, request);
        return SneakerResponse.from(sneaker);
    }

    @Transactional
    public void delete(Long id) {
        Sneaker sneaker = get(id);
        if (orderItems.existsBySneakerId(id)) {
            throw ApiException.conflict("No se puede eliminar: el tenis ya tiene pedidos. Pon el stock en 0.");
        }
        sneakers.delete(sneaker);
    }

    Sneaker get(Long id) {
        return sneakers.findById(id).orElseThrow(() -> ApiException.notFound("Tenis " + id + " no encontrado"));
    }

    private void apply(Sneaker sneaker, SneakerRequest request) {
        sneaker.setName(request.name().trim());
        sneaker.setDescription(request.description());
        sneaker.setPrice(request.price());
        sneaker.setStock(request.stock());
        sneaker.setGender(request.gender());
        sneaker.setColors(request.colors());
        sneaker.setSizes(request.sizes().stream().distinct().sorted().toList());
        sneaker.setImages(request.images() == null ? List.of() : request.images());
        sneaker.setBrand(catalog.getBrand(request.brandId()));
        sneaker.setCategory(catalog.getCategory(request.categoryId()));
    }
}
