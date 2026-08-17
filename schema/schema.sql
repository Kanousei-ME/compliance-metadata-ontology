-- Compliance Metadata Ontology — reference DDL (portable, illustrative).
-- This is the core of the model, not the full schema of any application.

CREATE TABLE product_specification (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(255) NOT NULL UNIQUE,
    category    VARCHAR(100),
    gmdn_code   VARCHAR(50),      -- adopt the standard nomenclature
    emdn_code   VARCHAR(50),      -- EMDN / EUDAMED
    consumption_type VARCHAR(20) NOT NULL DEFAULT 'discrete',  -- discrete | continuous
    consumption_unit VARCHAR(20) NOT NULL DEFAULT 'each',      -- display label
    consumption_unit_ucum VARCHAR(20),                      -- UCUM code: {each}, mL, g, m
    attributes  JSONB,            -- { size, sterility, material, ... }
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE product (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_type     VARCHAR(30) NOT NULL DEFAULT 'individual_product', -- individual_product | kit_template
    name             VARCHAR(255) NOT NULL,
    brand            VARCHAR(100),
    units_per_pack   INTEGER NOT NULL DEFAULT 1,
    unit_of_measure  VARCHAR(20) NOT NULL DEFAULT 'pc',
    specification_id UUID REFERENCES product_specification(id) ON DELETE SET NULL,
    udi_di           VARCHAR(100),
    gmdn_code        VARCHAR(50),
    emdn_code        VARCHAR(50)
);

CREATE TABLE kit_template_product (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    kit_template_id  UUID NOT NULL,
    specification_id UUID REFERENCES product_specification(id) ON DELETE SET NULL, -- what is needed
    product_id       UUID REFERENCES product(id) ON DELETE SET NULL,                -- optional canonical fill
    quantity         INTEGER NOT NULL DEFAULT 1,                                    -- packs
    is_mandatory     BOOLEAN NOT NULL DEFAULT true,
    UNIQUE (kit_template_id, specification_id)
);

CREATE TABLE compliance_standard (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name          VARCHAR(255) NOT NULL,          -- e.g. "ANSI/ISEA Z308.1"
    country       VARCHAR(3),                     -- ISO 3166-1 alpha-3 (future: FK to geography)
    version       VARCHAR(50),                    -- e.g. "2021"
    is_current    BOOLEAN NOT NULL DEFAULT true,
    superseded_at TIMESTAMPTZ,
    superseded_by UUID REFERENCES compliance_standard(id),
    UNIQUE (name, country, version)
);

CREATE TABLE compliance_rule (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    standard_id      UUID NOT NULL REFERENCES compliance_standard(id),
    specification_id UUID NOT NULL REFERENCES product_specification(id),
    quantity_units   INTEGER NOT NULL,            -- individual units
    UNIQUE (standard_id, specification_id)
);
