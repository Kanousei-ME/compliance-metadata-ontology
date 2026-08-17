# Mapping example — standard → specification → quantity

A compliance standard is a document; here it becomes data.

## Input (standard, as text)

> "A workplace first-aid kit (Class A) shall contain at least 16 adhesive bandages and 4 sterile gauze pads."

## As structured metadata

| standard | country | specification | quantity (units) |
|---|---|---|---|
| ANSI/ISEA Z308.1-2021, Class A | US | Adhesive bandage — size U | 16 |
| ANSI/ISEA Z308.1-2021, Class A | US | Sterile gauze pad — 10×10 cm | 4 |
| BS 8599-1:2019, small | GB | Adhesive bandage — size U | 20 |

## Why this fixes substitution

A kit requiring "adhesive bandage, size U" is compliant with **any** brand whose product carries that specification — brand X *or* brand Y. A shortage substitution changes the product, not the specification, so compliance is preserved.

## Why it fixes brand-specific matching

The same rule works across brands because the requirement is the *specification*, not the SKU. "Brand X, size U" and "Brand Y, size U" are two `product` rows pointing at one `product_specification`.
