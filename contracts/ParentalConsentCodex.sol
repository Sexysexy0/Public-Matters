// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ParentalConsentCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of parental consent safeguards
contract ParentalConsentCodex {
    address public overseer;
    uint256 public consentCount;

    struct ConsentEntry {
        uint256 id;
        string child;
        string parent;
        string procedure;
        string consentStatus;
        uint256 timestamp;
    }

    mapping(uint256 => ConsentEntry) public consents;

    event ConsentLogged(uint256 indexed id, string child, string parent, string procedure, string consentStatus);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logConsent(
        string calldata child,
        string calldata parent,
        string calldata procedure,
        string calldata consentStatus
    ) external onlyOverseer {
        consentCount++;
        consents[consentCount] = ConsentEntry({
            id: consentCount,
            child: child,
            parent: parent,
            procedure: procedure,
            consentStatus: consentStatus,
            timestamp: block.timestamp
        });
        emit ConsentLogged(consentCount, child, parent, procedure, consentStatus);
    }

    function viewConsent(uint256 id) external view returns (ConsentEntry memory) {
        return consents[id];
    }
}
