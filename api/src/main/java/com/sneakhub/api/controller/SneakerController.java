package com.sneakhub.api.controller;

import com.sneakhub.api.dto.SneakerDtos.SneakerRequest;
import com.sneakhub.api.dto.SneakerDtos.SneakerResponse;
import com.sneakhub.api.entity.Gender;
import com.sneakhub.api.service.SneakerService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/sneakers")
public class SneakerController {

    private final SneakerService sneakerService;

    public SneakerController(SneakerService sneakerService) {
        this.sneakerService = sneakerService;
    }

    /** Ej: /api/v1/sneakers?brandId=1&categoryId=3&gender=UNISEX&q=air */
    @GetMapping
    public List<SneakerResponse> findAll(@RequestParam(required = false) Long brandId,
                                         @RequestParam(required = false) Long categoryId,
                                         @RequestParam(required = false) Gender gender,
                                         @RequestParam(required = false) String q) {
        return sneakerService.findAll(brandId, categoryId, gender, q);
    }

    @GetMapping("/{id}")
    public SneakerResponse findById(@PathVariable Long id) {
        return sneakerService.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public SneakerResponse create(@Valid @RequestBody SneakerRequest request) {
        return sneakerService.create(request);
    }

    @PutMapping("/{id}")
    public SneakerResponse update(@PathVariable Long id, @Valid @RequestBody SneakerRequest request) {
        return sneakerService.update(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        sneakerService.delete(id);
    }
}
