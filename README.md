# Compliance Metadata Ontology

A machine-readable ontology for **medical-device compliance** — turning "is this kit compliant?" from a brand-and-product-specific check into a structured, auditable, metadata-driven rule.

## The problem

Compliance is usually tied to a specific SKU/brand: a kit requires *"adhesive bandage, size U, brand X"*. If the same size-U bandage arrives in **brand Y** (a shortage substitution), the system marks it non-compliant even though it is functionally identical. Rules also live in free text — PDFs and standards documents that can't be queried.

## The two layers

**1. Adopt the commodity.** Device naming and identification already have standards — don't reinvent them:

- [GMDN](https://www.gmdnagency.org/) — global medical device nomenclature
- [EMDN](https://health.ec.europa.eu/medical-devices-eudamed_en) — European Medical Device Nomenclature (EUDAMED)
- UDI (GS1 / HIBCC / ICCBBA) — device identification

**2. Own the mapping.** What does *not* exist as an adoptable standard is the machine-readable **rule → specification → quantity → country** mapping. Standards like ANSI/ISEA Z308.1 and BS 8599 specify "minimum types and quantities" as *documents*, not data. This repository defines that mapping layer.

## What's here

| Path | Contents |
|---|---|
| `docs/ontology.md` | the conceptual model: specification, attributes, rules, governance |
| `docs/ERD.md` | entity-relationship diagram |
| `docs/mapping-example.md` | worked example: standard → spec → quantity |
| `schema/schema.sql` | portable reference DDL |
| `data/specifications.example.json` | example specifications (GMDN/EMDN-coded) |
| `data/mappings.example.json` | example compliance mappings |

## Principles

- **Structured, not free-text.** Attributes use a governed vocabulary (`size`, `sterility`, `material`), never ad-hoc strings.
- **Spec-based, not brand-based.** Compliance matches the *specification*, so substitution never breaks it.
- **Traceable.** Every rule carries its source standard, country, and version.

## License

[Apache-2.0](LICENSE)
