package com.sneakhub.api.repository;

import com.sneakhub.api.entity.Gender;
import com.sneakhub.api.entity.Sneaker;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SneakerRepository extends JpaRepository<Sneaker, Long> {

    /** Cada filtro es opcional: si llega null, no se aplica. */
    @Query("""
            select s from Sneaker s
            where (:brandId is null or s.brand.id = :brandId)
              and (:categoryId is null or s.category.id = :categoryId)
              and (:gender is null or s.gender = :gender)
              and (:q is null or lower(s.name) like lower(concat('%', :q, '%')))
            order by s.id
            """)
    List<Sneaker> search(@Param("brandId") Long brandId,
                         @Param("categoryId") Long categoryId,
                         @Param("gender") Gender gender,
                         @Param("q") String q);
}
