// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InformedConsentCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of informed consent safeguards
contract InformedConsentCodex {
    address public overseer;
    uint256 public consentCount;

    struct ConsentEntry {
        uint256 id;
        string subject;
        string procedure;
        bool consentGiven;
        uint256 timestamp;
    }

    mapping(uint256 => ConsentEntry) public consents;

    event ConsentLogged(uint256 indexed id, string subject, string procedure, bool consentGiven);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logConsent(
        string calldata subject,
        string calldata procedure,
        bool consentGiven
    ) external onlyOverseer {
        consentCount++;
        consents[consentCount] = ConsentEntry({
            id: consentCount,
            subject: subject,
            procedure: procedure,
            consentGiven: consentGiven,
            timestamp: block.timestamp
        });
        emit ConsentLogged(consentCount, subject, procedure, consentGiven);
    }

    function viewConsent(uint256 id) external view returns (ConsentEntry memory) {
        return consents[id];
    }
}
