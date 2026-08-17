# Contributing

## Governance rules

1. **Adopt the standard.** A `product_specification` must carry a GMDN/EMDN code where one exists — do not invent a new vocabulary for something already named by a standard.
2. **Structured attributes.** Attributes use the governed vocabulary (`size`, `sterility`, `material`, …). No ad-hoc free-text tags.
3. **Traceable rules.** Every rule must cite its source standard, country, and version.
4. **Validated mappings.** A rule may not reference a specification that does not exist.

## Adding a mapping

1. Add the specification to `data/specifications.example.json` (or the catalogue).
2. Add the rule to `data/mappings.example.json`.
3. Validate: every referenced specification exists; quantities are positive integers in individual units.

## License

Apache-2.0. By contributing, you agree to license your contribution under Apache-2.0.
