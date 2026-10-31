# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - Unreleased

### Changed

- **Breaking:** base image updated to `bfren/node` 6.0.0 - see the
  [Node.js changelog](https://github.com/bfren/docker-node/blob/main/CHANGELOG.md).
  `bf env set` must now run as root.
- Send updated to 3.5.0.
- Built on Node.js 26 instead of Node.js 24.
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

[4.0.0]: https://github.com/bfren/docker-send/compare/v3.1.3...v4.0.0
