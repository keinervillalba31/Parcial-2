# SneakHub API

API REST de una tienda de tenis, hecha con **Spring Boot 4**, **Spring Security + JWT** y **H2** (base de datos en archivo).

## Cómo correrla

Requiere JDK 17 o superior (no necesitas instalar Maven, viene el wrapper `mvnw`).

```bash
cd api
.\mvnw.cmd spring-boot:run    # Windows (PowerShell)
./mvnw spring-boot:run        # Git Bash / Linux / Mac
```

Queda en **http://localhost:8081**. La primera vez crea la base `data/sneakhub.mv.db` con datos de ejemplo.
Para empezar de cero, detén la API y borra la carpeta `data/`.

| Usuario | Contraseña | Rol |
|---|---|---|
| admin@sneakhub.com | admin123 | ADMIN |
| cliente@sneakhub.com | cliente123 | CUSTOMER |

Consola de la BD: http://localhost:8081/h2-console (JDBC URL `jdbc:h2:file:./data/sneakhub`, usuario `sa`, sin contraseña).

## Estructura

```
src/main/java/com/sneakhub/api/
├── config/       SecurityConfig (reglas de acceso), JwtConfig (firma de tokens), DataSeeder (datos iniciales)
├── entity/       Tablas: User, Brand, Category, Sneaker, Order, OrderItem (+ enums Role, Gender, OrderStatus)
├── repository/   Acceso a datos (Spring Data JPA)
├── dto/          Lo que entra y sale en JSON (records)
├── service/      Lógica de negocio (validar stock, tallas, tokens...)
├── controller/   Endpoints REST
└── exception/    Errores en JSON: { status, message, errors, timestamp }
```

## Endpoints (`/api/v1`)

🔓 público · 🔑 con token · 👑 solo ADMIN. El token va en el header `Authorization: Bearer <access_token>`.

### Auth
| Método | Ruta | | Body / Respuesta |
|---|---|---|---|
| POST | `/auth/login` | 🔓 | `{ "email", "password" }` → `{ access_token, refresh_token, token_type, expires_in }` |
| POST | `/auth/register` | 🔓 | `{ "name", "email", "password", "avatar"? }` → tokens (rol CUSTOMER) |
| POST | `/auth/refresh` | 🔓 | `{ "refresh_token" }` → tokens nuevos |
| GET | `/auth/profile` | 🔑 | `{ id, name, email, role, avatar }` |

### Tenis
| Método | Ruta | | |
|---|---|---|---|
| GET | `/sneakers` | 🔓 | Filtros opcionales: `?brandId=1&categoryId=3&gender=UNISEX&q=air` |
| GET | `/sneakers/{id}` | 🔓 | Detalle con marca y categoría |
| POST | `/sneakers` | 👑 | Crear |
| PUT | `/sneakers/{id}` | 👑 | Editar |
| DELETE | `/sneakers/{id}` | 👑 | Eliminar (409 si ya tiene pedidos) |

Body de crear/editar:
```json
{
  "name": "Nike Dunk Low",
  "description": "Clásico del skate",
  "price": 529900,
  "stock": 10,
  "gender": "UNISEX",
  "colors": "Verde, Blanco",
  "sizes": [38, 39, 40, 41],
  "images": ["https://..."],
  "brandId": 1,
  "categoryId": 4
}
```
`gender`: `HOMBRE`, `MUJER` o `UNISEX`.

### Marcas y categorías
| Método | Ruta | | |
|---|---|---|---|
| GET | `/brands`, `/brands/{id}` | 🔓 | `{ id, name, logo }` |
| POST | `/brands` | 👑 | `{ "name", "logo"? }` |
| GET | `/categories`, `/categories/{id}` | 🔓 | `{ id, name }` |
| POST | `/categories` | 👑 | `{ "name" }` |

### Pedidos
| Método | Ruta | | |
|---|---|---|---|
| POST | `/orders` | 🔑 | `{ "items": [ { "sneakerId": 1, "size": 40, "quantity": 2 } ] }` — valida talla y stock, y descuenta el stock |
| GET | `/orders` | 🔑 | El cliente ve los suyos; el ADMIN ve todos |
| GET | `/orders/{id}` | 🔑 | Detalle (403 si es de otro usuario) |
| PATCH | `/orders/{id}/status` | 👑 | `{ "status": "PAGADO" }` — `PENDIENTE`, `PAGADO`, `ENVIADO`, `ENTREGADO`, `CANCELADO` (cancelar devuelve el stock) |

## Códigos de respuesta
`200` OK · `201` creado · `204` eliminado · `400` datos inválidos · `401` sin token / credenciales malas · `403` sin permiso · `404` no existe · `409` conflicto (correo repetido, tenis con pedidos)
