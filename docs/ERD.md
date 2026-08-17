# ERD

```mermaid
erDiagram
    PRODUCT_SPECIFICATION ||--o{ PRODUCT : classifies
    PRODUCT_SPECIFICATION ||--o{ KIT_TEMPLATE_PRODUCT : "required by"
    PRODUCT ||--o{ KIT_TEMPLATE_PRODUCT : "canonical fill"
    PRODUCT_SPECIFICATION ||--o{ COMPLIANCE_RULE : "required by"
    COMPLIANCE_STANDARD ||--o{ COMPLIANCE_RULE : defines

    PRODUCT_SPECIFICATION {
        uuid id PK
        string name UK
        string category
        string gmdn_code
        string emdn_code
        string consumption_type
        string consumption_unit
        string consumption_unit_ucum
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
    COMPLIANCE_STANDARD {
        uuid id PK
        string name
        string country
        string version
        bool is_current
        timestamp superseded_at
    }
    COMPLIANCE_RULE {
        uuid standard_id FK
        uuid specification_id FK
        int quantity_units
    }
```

## Key relationships

- **`product_specification → product`** — a specification classifies many products (brands). `product.specification_id` is nullable until a SKU is mapped.
- **`product_specification → kit_template_product`** — a kit line requires a specification; any product of that spec satisfies it.
- **`product → kit_template_product`** — the optional "canonical fill" (the preferred brand), used for defaults and quoting, not compliance.
- **`compliance_standard → compliance_rule`** — a standard defines its required specs and quantities, versioned and country-scoped.
- **`product_specification → compliance_rule`** — the same specification can be required by many standards.
