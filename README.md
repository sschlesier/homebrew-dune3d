# homebrew-dune3d

Homebrew tap for [Dune3D](https://dune3d.org), a parametric 3D CAD application.

## Install

```sh
brew install sschlesier/dune3d/dune3d
```

## Updating for a new upstream release

### 1. Check for a new version

```sh
brew livecheck sschlesier/dune3d/dune3d
```

### 2. Get the sha256 of the new source tarball

```sh
curl -sL https://github.com/dune3d/dune3d/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
```

### 3. Edit `Formula/dune3d.rb`

- Update the `url` to the new tag
- Update the `sha256` to the value from step 2
- **Remove the existing `bottle do` block** — the CI workflow skips bottle builds if one is present

### 4. Push to main

```sh
git add Formula/dune3d.rb
git commit -m "feat: update dune3d to vX.Y.Z"
git push
```

CI will build the bottle, upload it to GitHub Releases as `dune3d-X.Y.Z`, and commit the new `bottle do` block back to the formula automatically.

## How bottles work

Bottles are ARM64 binaries built on `macos-15` in CI, eliminating the need to compile locally (which requires downloading ~1.9 GB of LLVM). When a version bump is pushed:

1. `brew install --build-bottle` compiles the formula
2. `brew bottle --json` produces a `.tar.gz` and metadata
3. The tarball is uploaded to the GitHub Release for that version
4. `brew bottle --merge` writes the `bottle do` block back into the formula

If CI fails after creating the GitHub Release but before committing the bottle block, remove the `bottle do` block from the formula and push a commit to re-trigger the workflow.

## Workflows

| Workflow | Trigger | Purpose |
|---|---|---|
| `test.yml` | Push / PR touching `Formula/**` | Build from source, run `brew test` and `brew audit` |
| `publish.yml` | Push to `main` touching `Formula/**` | Build bottle, publish release, commit bottle block |
| `smoke-test.yml` | Monday 8am UTC | Weekly build from source to catch dependency breakage |
