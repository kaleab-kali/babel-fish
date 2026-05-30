# Security

## Supported versions

Babel Fish is pre-release. Security fixes apply to the main branch until versioned releases exist.

## Reporting a vulnerability

Please do not open a public issue for vulnerabilities, leaked secrets, or private data exposure.

Use GitHub private vulnerability reporting if enabled, or contact the maintainer through GitHub with:

- A short description of the issue.
- Steps to reproduce.
- Potential impact.
- Any logs or screenshots with secrets removed.

## Secrets and provider keys

Provider credentials must stay outside git. Use local environment configuration and commit only safe examples such as `.env.example`.

Run `dart tool/verify_no_secrets.dart` before opening pull requests. The same check runs in the Dart workspace GitHub Actions workflow.
