package com.sneakhub.api.controller;

import com.sneakhub.api.dto.CatalogDtos.*;
import com.sneakhub.api.service.CatalogService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/** Marcas (/api/v1/brands) y categorías (/api/v1/categories). */
@RestController
@RequestMapping("/api/v1")
public class CatalogController {

    private final CatalogService catalogService;

    public CatalogController(CatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping("/brands")
    public List<BrandResponse> brands() {
        return catalogService.findBrands();
    }

    @GetMapping("/brands/{id}")
    public BrandResponse brand(@PathVariable Long id) {
        return catalogService.findBrand(id);
    }

    @PostMapping("/brands")
    @ResponseStatus(HttpStatus.CREATED)
    public BrandResponse createBrand(@Valid @RequestBody BrandRequest request) {
        return catalogService.createBrand(request);
    }

    @GetMapping("/categories")
    public List<CategoryResponse> categories() {
        return catalogService.findCategories();
    }

    @GetMapping("/categories/{id}")
    public CategoryResponse category(@PathVariable Long id) {
        return catalogService.findCategory(id);
    }

    @PostMapping("/categories")
    @ResponseStatus(HttpStatus.CREATED)
    public CategoryResponse createCategory(@Valid @RequestBody CategoryRequest request) {
        return catalogService.createCategory(request);
    }
}
