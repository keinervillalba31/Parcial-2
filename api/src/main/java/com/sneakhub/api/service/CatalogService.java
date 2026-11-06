package com.sneakhub.api.service;

import com.sneakhub.api.dto.CatalogDtos.*;
import com.sneakhub.api.entity.Brand;
import com.sneakhub.api.entity.Category;
import com.sneakhub.api.exception.ApiException;
import com.sneakhub.api.repository.BrandRepository;
import com.sneakhub.api.repository.CategoryRepository;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/** Marcas y categorías (se usan para los filtros y los dropdowns del formulario). */
@Service
public class CatalogService {

    private final BrandRepository brands;
    private final CategoryRepository categories;

    public CatalogService(BrandRepository brands, CategoryRepository categories) {
        this.brands = brands;
        this.categories = categories;
    }

    @Transactional(readOnly = true)
    public List<BrandResponse> findBrands() {
        return brands.findAll(Sort.by("name")).stream().map(BrandResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public BrandResponse findBrand(Long id) {
        return BrandResponse.from(getBrand(id));
    }

    @Transactional
    public BrandResponse createBrand(BrandRequest request) {
        if (brands.existsByNameIgnoreCase(request.name().trim())) {
            throw ApiException.conflict("Ya existe la marca " + request.name());
        }
        return BrandResponse.from(brands.save(new Brand(request.name().trim(), request.logo())));
    }

    @Transactional(readOnly = true)
    public List<CategoryResponse> findCategories() {
        return categories.findAll(Sort.by("name")).stream().map(CategoryResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public CategoryResponse findCategory(Long id) {
        return CategoryResponse.from(getCategory(id));
    }

    @Transactional
    public CategoryResponse createCategory(CategoryRequest request) {
        if (categories.existsByNameIgnoreCase(request.name().trim())) {
            throw ApiException.conflict("Ya existe la categoría " + request.name());
        }
        return CategoryResponse.from(categories.save(new Category(request.name().trim())));
    }

    Brand getBrand(Long id) {
        return brands.findById(id).orElseThrow(() -> ApiException.notFound("Marca " + id + " no encontrada"));
    }

    Category getCategory(Long id) {
        return categories.findById(id).orElseThrow(() -> ApiException.notFound("Categoría " + id + " no encontrada"));
    }
}
