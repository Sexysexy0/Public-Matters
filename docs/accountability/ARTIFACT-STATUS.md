# Artifact Status and Evidence Model

## Purpose

This document defines how Public-Matters describes source code, test results,
deployment records, and related evidence. It is intended to prevent public
documentation from overstating technical, operational, legal, or institutional
status.

## Status terms

| Status | Meaning |
|---|---|
| Source artifact | Source code, test code, documentation, or a design artifact stored in this repository. |
| Local development deployment | A deployment to a local development environment, such as Anvil. It is not a public network deployment. |
| Public testnet deployment | A deployment to a public test network, such as Ethereum Sepolia or Polygon Amoy. It is not a production or mainnet deployment. |
| Production/mainnet deployment | A deployment to a production network. This status requires chain, address, transaction, source-verification status, administrative model, and supporting evidence. |
| Failed deployment attempt | An attempted deployment that did not complete successfully or was not verified as successful. |
| Deprecated artifact | A source or deployment record no longer recommended for current use. |
| Evidence reconciliation required | Records conflict, are incomplete, or do not yet support a single reliable public status. |

## Evidence requirements

A public deployment claim should identify, where applicable:

- Network name and chain ID.
- Contract name and deployed address.
- Transaction hash or deployment record.
- Date or evidence-record version.
- Whether source-code verification is available on a named block explorer.
- Administrative or ownership model only to the extent intentionally public.
- Whether the claim concerns local development, a testnet, or production.

A runtime check, including a `cast code` or `cast call` result, is evidence that
a repository operator recorded a particular response at a point in time. It is
not an independent security audit, production-readiness finding, legal opinion,
institutional authorization, or proof of external adoption.

## Current public boundary

The repository contains source code, tests, research, policy-prototyping
materials, local-development records, and public testnet deployment records.
Nothing in this repository, including source code and testnet records, by
itself establishes production deployment, legal authority, public institutional
authority, regulatory approval, custody, financial authority, external
adoption, or control of a third-party system. Such a claim requires separate
authorized and verifiable evidence.

## Reconciliation note

Some historical deployment records require reconciliation. For example,
InstitutionalResetRegistry has conflicting Sepolia and Polygon Amoy references
across repository documents. Until reconciled through evidence, related claims
must use the status **evidence reconciliation required**.
