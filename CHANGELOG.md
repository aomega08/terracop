# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.2.0 (2019-12-28)

- New cops:
  - Aws/BadPasswordPolicy
  - Aws/EnsurePropagatedTags
  - Aws/FaultIntolerant
  - Aws/IamInlinePolicy
  - Aws/IamPolicyAttachment
  - Aws/PreferLaunchTemplates
- Deprecated cop: IamRolePolicy.
- Improve test coverage.
- Improve Aws/EnsureTags to handle weird resources.
- Ignore deletions when analyzing plans.

## 0.1.1 (2019-12-22)

- Exit with failure when offenses are found.
- Add `terracop` executable.

## 0.1.0 (2019-12-22)

- Initial release.
- Can load Terraform 0.12 state and plan files.
- Performs a number of generic checks on all resources.
- Performs some AWS-specific security checks on some resources.
- Loads a default configuration file.
- Allows configuration overrides through `.terracop.yml`.
