// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConsentCodex
/// @notice Covenant contract to safeguard consent in digital systems,
///         ensuring voluntary participation and revocable rights.
contract ConsentCodex {
    address public overseer;
    uint256 public consentCount;

    struct ConsentRule {
        uint256 id;
        string principle;   // Consent, Revocation, Transparency, RightsProtection
        string description; // Encoded safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ConsentRule) public consents;

    event ConsentDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Declare a new consent safeguard
    function declareConsent(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        consentCount++;
        consents[consentCount] = ConsentRule({
            id: consentCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ConsentDeclared(consentCount, principle, description);
    }

    /// @notice View a specific consent safeguard
    function viewConsent(uint256 id) external view returns (ConsentRule memory) {
        return consents[id];
    }
}
