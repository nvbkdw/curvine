# Repository Guidelines

## Project Structure & Module Organization
- Rust workspace: `curvine-server/` hosts core services, `curvine-common/` holds shared protocol/state, and `orpc/` exposes RPC plumbing.
- Client tooling resides in `curvine-client/`, `curvine-libsdk/`, and `curvine-cli/`.
- Storage gateways sit in `curvine-fuse/`, `curvine-s3-gateway/`, and `curvine-ufs/`; the Go-based CSI driver lives in `curvine-csi/`.
- Integration suites live in `curvine-tests/`; automation scripts in `build/`; deployment templates in `etc/`.

## Build, Test, and Development Commands
- `make check-env` audits LLVM, Protobuf, FUSE, and other prerequisites.
- `make build ARGS='-p server'` (omit `ARGS` for full release) compiles via `build/build.sh` and writes artifacts to `build/dist/`.
- `make cargo ARGS='test --workspace --release'` or `cargo test --workspace` runs the Rust suite; release mode mirrors CI’s `build/run-tests.sh`.
- `make format` runs the required `cargo fmt` and `cargo clippy --fix`; rerun until clippy is warning-free.
- `make csi-build` / `make csi-run` cover the Go CSI plugin with `go fmt` and `go vet`.

## Coding Style & Naming Conventions
- Enforce `rustfmt.toml`: 100-column width, four-space indents, Unix newlines, no tabs.
- Keep crates `kebab-case`, modules `snake_case`, types `CamelCase`, constants `SCREAMING_SNAKE_CASE`.
- Clippy warnings are denied in CI; lint in both debug and release before sending reviews.
- Go sources must pass `go fmt`/`go vet`; shell scripts in `build/` should stay POSIX-compatible.

## Testing Guidelines
- Default to `cargo test --workspace`; add targeted runs (`cargo test -p curvine-ufs --test s3`) when touching specific gateways.
- Expand end-to-end coverage under `curvine-tests/tests/` and note any topology or data prerequisites in the accompanying README.
- Prefer deterministic fixtures from `curvine-tests/examples/` and descriptive `#[test]` names that mirror behavior.
- Run `build/run-tests.sh` for the release-mode regression suite before large PRs.

## Commit & Pull Request Guidelines
- Use Conventional Commits with linked issues, e.g. `feat(storage): add tiered warmup (#123)`; `npm run commitlint` validates the latest commit.
- Branch from `main`, describe scope, list executed checks, and update docs/configs alongside code.
- Attach metrics, screenshots, or benchmark notes for user-facing or performance-sensitive changes.

## Security & Configuration Tips
- Report vulnerabilities per `SECURITY.md`; never commit secrets.
- Start from the templates in `etc/` when introducing new service or deployment definitions.
