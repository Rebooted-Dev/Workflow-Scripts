---
id: code-design
kind: standard
status: active
---

# Code Design Standard

Use this standard for implementation and review when code structure, maintainability, or module boundaries are in scope.

## Contract

- Boundaries follow the design brief or current architecture. Each module has a clear responsibility, owned data, and public interface.
- Information hiding is explicit: callers depend on the smallest useful interface, not internal storage or incidental helpers.
- Invariants are enforced in one place, preferably at construction, parsing, or boundary entry.
- Domain logic does not import UI, transport, filesystem, database, or provider concerns unless the project architecture explicitly allows it.
- Make invalid states hard to represent. Prefer typed/domain objects over repeated primitive validation.
- Avoid untyped escape hatches. `any`, unchecked casts, disabled strictness, reflection, or dynamic mutation need a debt entry when retained.
- Prefer composition over inheritance. Inheritance must preserve substitutability and expose a smaller surface than the duplicated alternative.
- Resource ownership is clear. Long-lived processes use bounded queues/caches, deterministic cleanup, and no unbounded growth.
- Mutation is local and intentional. Shared mutable state needs synchronization or a documented single-owner rule.
- Public APIs are documented enough for a caller to know valid inputs, outputs, errors, and stability expectations.

## Review Questions

- What can change inside this module without touching callers?
- Where is each invariant enforced?
- Which dependencies point inward toward domain logic, and which leak outward concerns?
- Are type escapes or disabled checks deliberate, temporary, and ledgered?

## Ecosystem Notes

| Ecosystem | Minimum expectation |
|---|---|
| TypeScript | `strict` on; no unreviewed `any`; parse external data at boundaries. |
| Python | Type annotations for public interfaces; runtime validation at trust boundaries. |
| Rust | Prefer ownership/lifetime guarantees over runtime flags; avoid unnecessary `unsafe`. |
| Go | Small interfaces at consumers; explicit ownership and cleanup with `defer`/contexts. |
