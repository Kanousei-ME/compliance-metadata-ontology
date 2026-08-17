# ERD

```mermaid
erDiagram
    PRODUCT_SPECIFICATION ||--o{ PRODUCT : classifies
    PRODUCT_SPECIFICATION ||--o{ KIT_TEMPLATE_PRODUCT : "required by"
    PRODUCT ||--o{ KIT_TEMPLATE_PRODUCT : "canonical fill"

    PRODUCT_SPECIFICATION {
        uuid id PK
        string name UK
        string category
        string gmdn_code
        string emdn_code
        json attributes
    }
    PRODUCT {
        uuid id PK
        enum product_type
        string name
        string brand
        int units_per_pack
        string unit_of_measure
        uuid specification_id FK
        string udi_di
    }
    KIT_TEMPLATE_PRODUCT {
        uuid specification_id FK
        uuid product_id FK
        int quantity
        bool is_mandatory
    }
```

## Key relationships

- **`product_specification → product`** — a specification classifies many products (brands). `product.specification_id` is nullable until a SKU is mapped.
- **`product_specification → kit_template_product`** — a kit line requires a specification; any product of that spec satisfies it.
- **`product → kit_template_product`** — the optional "canonical fill" (the preferred brand), used for defaults and quoting, not for compliance.
