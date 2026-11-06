package com.sneakhub.api.config;

import com.sneakhub.api.entity.*;
import com.sneakhub.api.repository.BrandRepository;
import com.sneakhub.api.repository.CategoryRepository;
import com.sneakhub.api.repository.SneakerRepository;
import com.sneakhub.api.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/** Carga datos de ejemplo la primera vez que arranca la API (si la base está vacía). */
@Component
public class DataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    private final UserRepository users;
    private final BrandRepository brands;
    private final CategoryRepository categories;
    private final SneakerRepository sneakers;
    private final PasswordEncoder passwordEncoder;

    public DataSeeder(UserRepository users, BrandRepository brands, CategoryRepository categories,
                      SneakerRepository sneakers, PasswordEncoder passwordEncoder) {
        this.users = users;
        this.brands = brands;
        this.categories = categories;
        this.sneakers = sneakers;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(String... args) {
        if (users.count() > 0) {
            return;
        }

        users.save(new User("Administrador SneakHub", "admin@sneakhub.com",
                passwordEncoder.encode("admin123"), Role.ADMIN, "https://i.pravatar.cc/150?img=12"));
        users.save(new User("Cliente Demo", "cliente@sneakhub.com",
                passwordEncoder.encode("cliente123"), Role.CUSTOMER, "https://i.pravatar.cc/150?img=5"));

        Brand nike = brands.save(new Brand("Nike", image("Nike")));
        Brand adidas = brands.save(new Brand("Adidas", image("Adidas")));
        Brand puma = brands.save(new Brand("Puma", image("Puma")));
        Brand newBalance = brands.save(new Brand("New Balance", image("New Balance")));
        Brand converse = brands.save(new Brand("Converse", image("Converse")));
        Brand vans = brands.save(new Brand("Vans", image("Vans")));

        Category running = categories.save(new Category("Running"));
        Category basketball = categories.save(new Category("Basketball"));
        Category lifestyle = categories.save(new Category("Lifestyle"));
        Category skate = categories.save(new Category("Skate"));
        Category training = categories.save(new Category("Training"));

        List<Integer> men = List.of(38, 39, 40, 41, 42, 43, 44);
        List<Integer> women = List.of(34, 35, 36, 37, 38, 39);
        List<Integer> unisex = List.of(35, 36, 37, 38, 39, 40, 41, 42, 43);

        sneakers.saveAll(List.of(
                sneaker("Nike Air Max 90", "Ícono de los 90 con unidad Air visible en el talón y capellada de cuero y malla.",
                        649900, 25, Gender.UNISEX, "Blanco, Negro, Rojo", unisex, nike, lifestyle),
                sneaker("Nike Air Force 1 '07", "El clásico del baloncesto llevado a la calle. Cuero premium y suela de goma.",
                        549900, 40, Gender.UNISEX, "Blanco", unisex, nike, lifestyle),
                sneaker("Nike Pegasus 41", "Tenis de running para el día a día con espuma ReactX y amortiguación Air Zoom.",
                        599900, 18, Gender.HOMBRE, "Negro, Azul", men, nike, running),
                sneaker("Nike LeBron XXI", "Diseñado para jugadores explosivos: soporte lateral y amortiguación Zoom Turbo.",
                        899900, 8, Gender.HOMBRE, "Morado, Dorado", men, nike, basketball),
                sneaker("Nike Metcon 9", "Estable para levantar pesas y flexible para el cardio. Ideal para crossfit.",
                        629900, 12, Gender.HOMBRE, "Gris, Negro", men, nike, training),
                sneaker("Adidas Ultraboost 5", "Máximo retorno de energía con espuma Boost y Light BOOST.",
                        799900, 15, Gender.MUJER, "Blanco, Rosa", women, adidas, running),
                sneaker("Adidas Samba OG", "Nacido en las canchas de fútbol, hoy un ícono urbano. Cuero y gamuza.",
                        519900, 30, Gender.UNISEX, "Blanco, Negro", unisex, adidas, lifestyle),
                sneaker("Adidas Forum Low", "Estilo retro de baloncesto de los 80 con correa en el tobillo.",
                        489900, 20, Gender.UNISEX, "Blanco, Azul", unisex, adidas, lifestyle),
                sneaker("Adidas Dropset 3", "Tenis de entrenamiento con base firme para sentadillas y peso muerto.",
                        559900, 10, Gender.MUJER, "Negro", women, adidas, training),
                sneaker("Puma Suede Classic", "La gamuza más famosa desde 1968. Comodidad y estilo de siempre.",
                        349900, 35, Gender.UNISEX, "Azul, Rojo, Negro", unisex, puma, lifestyle),
                sneaker("Puma Velocity Nitro 3", "Espuma NITRO para carreras largas con gran amortiguación y poco peso.",
                        579900, 14, Gender.HOMBRE, "Amarillo, Negro", men, puma, running),
                sneaker("New Balance 574", "El tenis más versátil de New Balance. Amortiguación ENCAP y gamuza.",
                        459900, 22, Gender.UNISEX, "Gris, Azul marino", unisex, newBalance, lifestyle),
                sneaker("New Balance Fresh Foam 1080", "Amortiguación Fresh Foam X para correr largas distancias con suavidad.",
                        749900, 9, Gender.MUJER, "Lila, Blanco", women, newBalance, running),
                sneaker("Converse Chuck Taylor All Star", "Lona resistente y suela vulcanizada. Un clásico desde 1917.",
                        279900, 50, Gender.UNISEX, "Negro, Blanco, Rojo", unisex, converse, lifestyle),
                sneaker("Vans Old Skool", "El primer Vans con la franja lateral. Suela waffle con gran agarre para skate.",
                        319900, 28, Gender.UNISEX, "Negro, Blanco", unisex, vans, skate),
                sneaker("Vans Sk8-Hi", "Caña alta acolchada para mayor soporte en el tobillo al patinar.",
                        349900, 0, Gender.UNISEX, "Negro, Blanco", unisex, vans, skate)
        ));

        log.info("Datos de ejemplo cargados. Admin: admin@sneakhub.com / admin123 · Cliente: cliente@sneakhub.com / cliente123");
    }

    private Sneaker sneaker(String name, String description, double price, int stock, Gender gender,
                            String colors, List<Integer> sizes, Brand brand, Category category) {
        Sneaker s = new Sneaker();
        s.setName(name);
        s.setDescription(description);
        s.setPrice(price);
        s.setStock(stock);
        s.setGender(gender);
        s.setColors(colors);
        s.setSizes(sizes);
        s.setImages(List.of(image(name), image(name, "ff5a1f"), image(name, "2a2a2a")));
        s.setBrand(brand);
        s.setCategory(category);
        return s;
    }

    /** Imagen de relleno (PNG). Se puede reemplazar por fotos reales desde el formulario. */
    private static String image(String text) {
        return image(text, "111111");
    }

    private static String image(String text, String background) {
        return "https://placehold.co/600x400/" + background + "/ffffff/png?text="
                + URLEncoder.encode(text, StandardCharsets.UTF_8);
    }
}
