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
| `consumption_unit` | governed unit of usage: `pc`, `pair`, `ml`, `g`, `m`, `wipe`, `roll`, … |

`product.unit_of_measure` (a free-text brand-level string today) should **derive** from `consumption_unit` — the specification is the source of truth.

## Governance (the moat)

The value is the *maintained, validated mapping*, not the schema:

1. Every `product_specification` carries a GMDN/EMDN code where one exists.
2. Every rule carries its source standard, country, and version.
3. A mapping may not reference a specification that doesn't exist — mappings are validated before entering the catalogue.
