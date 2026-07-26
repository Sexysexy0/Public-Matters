# 🔐 Security Policy

## Supported Versions
We actively maintain and patch the following versions of Public Matters:

| Version | Supported |
|---------|-----------|
| main    | ✅ |
| dev     | ✅ |
| old     | ❌ |

## Reporting a Vulnerability
We take security issues seriously. If you discover a vulnerability:

- **Do not open a public issue.**
- **Do not disclose publicly until it is patched.**

### Steps
1. Email the core team at **security@publicmatters.org**
2. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### Response
- We will acknowledge receipt within 48 hours.
- We will provide a status update within 7 days.
- Once resolved, we will publish a security advisory.

## Best Practices
- Always run `slither ./contracts` before submitting PRs.
- Ensure reentrancy guards and access control modifiers are applied.
- Document upgrade steps for proxy contracts.
- Emit events for all critical state changes.
- Validate all inputs to prevent out‑of‑range errors.
- Functions should revert on invalid states rather than silently succeed.
- Optimize loops and mappings to keep governance flows affordable.
- Include negative tests for unauthorized access, invalid inputs, and double execution attempts.
