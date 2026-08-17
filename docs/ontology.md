# Ontology — the conceptual model

## Core idea

Compliance is evaluated against a product's **functional specification**, not its brand/SKU. Two brands of "adhesive bandage, size U, sterile" share one `product_specification`, and both satisfy the same requirement.

## Entities

### `product_specification` — the anchor

The functional "what a device is", brand-independent.

| Field | Meaning |
|---|---|
| `name` | canonical spec, e.g. "Adhesive bandage — size U, sterile" |
| `category` | bandage / dressing / glove / … |
| `gmdn_code` / `emdn_code` | adopt the standard nomenclature — don't invent |
| `attributes` | governed, structured vocabulary: `{ size, sterility, material, … }` |

### `product` — items *and* kit templates

A unique item and a kit template are both products, distinguished by `product_type`. Each declares its `specification_id` ("what it is"). It also carries UDI and the pack/unit grouping.

### `kit_template_product` — the requirement

A kit line states what is *needed* (`specification_id`), optionally with a canonical fill (`product_id`).

### The rule — the compliance mapping

```
standard + country  →  required specification + quantity
```

## Quantity & units

- All quantities are **individual units** (`expected_quantity`, `current_quantity`, `quantity_used`).
- `units_per_pack` is a purchase grouping; template lines are in **packs**; kit contents and incident usage are in **units**.

**Example:** "Adhesive bandage, box of 100" → `units_per_pack = 100`. A template line = `2` packs. Kit contents = `expected_quantity = 200` units. An incident using 3 → `quantity_used = 3`.

## Units of usage

The unit a product is *consumed* in is a functional property of the specification, not the brand. Two brands of bandage are both counted in `pc`; saline is measured in `ml`; gloves in `pair`.

| Field | Meaning |
|---|---|
| `consumption_type` | `discrete` (whole items) \| `continuous` (measured: ml, g, m) |
| `consumption_unit` | governed unit of usage: `each`, `pair`, `ml`, `g`, `m`, `wipe`, `roll`, … |

`product.unit_of_measure` (a free-text brand-level string today) should **derive** from `consumption_unit` — the specification is the source of truth.

## Governance (the moat)

The value is the *maintained, validated mapping*, not the schema:

1. Every `product_specification` carries a GMDN/EMDN code where one exists.
2. Every rule carries its source standard, country, and version.
3. A mapping may not reference a specification that doesn't exist — mappings are validated before entering the catalogue.

## Global scale — roadmap & open questions

The model is **architecture-global, data-local**: GMDN/EMDN naming and country-parameterized rules scale without schema change, but three primitives are currently US/UK-shaped and must be hardened before multi-country use — free-text attributes, free-text units, and kit-contents-only compliance.

### 1. Units → UCUM (adopt the commodity)

`consumption_unit` is free text today (`each`, `ml`, `pair`). For machine-readability across jurisdictions, store [UCUM](https://ucum.org) codes (`{each}`, `mL`) alongside a display label — the same "adopt the standard" move made for GMDN.

- **Open question:** UCUM code + display label, or UCUM only?

### 2. Canonical geography reference

Rules carry `country` as a free string today. A global system needs canonical geography rows (country, region, ISO code) that rules reference, so `GB` vs `UK` vs `United Kingdom` cannot drift.

### 3. Standard versioning & supersession

A rule must know *which version* of a standard it encodes and when it was superseded — otherwise stale compliance rules ship. Today the version is embedded in the `standard` string (`ANSI/ISEA Z308.1-2021`), not structured.

- **Model:** `version` / `is_current` / `superseded_at` (the same append-and-supersede shape used for risk outcomes).

### 4. Attribute normalization

`size: "U"` (BS) vs ANSI sizing; `10×10 cm` vs `4×4 in`. Two specs can be functionally identical but structurally un-matchable. Needs a canonical (metric) attribute form plus region display.

- **Open question:** canonical-attributes + region-display columns, or a separate attribute-mapping table?

### 5. Internationalization

`name` / `category` are English. Global use needs `product_specification_translation` (BCP-47 locale), mirroring the app's existing `product_translation` pattern.

### 6. Regime separation

The ontology models *kit contents*. The broader compliance layer — RIDDOR (UK), OSHA recordkeeping (US), in-country equivalents — has its own thresholds, deadlines, forms, and responsible-person rules, and is a **separate axis** (a "regime instance" model), not more kit-content rules.

### 7. GMDN licensing (practical note)

GMDN is a **licensed** database (GMDN Agency membership); EMDN is free. Referencing `gmdn_code` is fine; publishing the actual GMDN term tables is not. The real mapping data must stay private/authorized — consistent with the open-core framing (schema public, curated data private).
