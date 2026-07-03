// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrivacyCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of privacy safeguards
contract PrivacyCodex {
    address public overseer;
    uint256 public privacyCount;

    struct PrivacyEntry {
        uint256 id;
        string subject;
        string guardian;
        string scope;
        uint256 timestamp;
    }

    mapping(uint256 => PrivacyEntry) public privacies;

    event PrivacyLogged(uint256 indexed id, string subject, string guardian, string scope);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPrivacy(
        string calldata subject,
        string calldata guardian,
        string calldata scope
    ) external onlyOverseer {
        privacyCount++;
        privacies[privacyCount] = PrivacyEntry({
            id: privacyCount,
            subject: subject,
            guardian: guardian,
            scope: scope,
            timestamp: block.timestamp
        });
        emit PrivacyLogged(privacyCount, subject, guardian, scope);
    }

    function viewPrivacy(uint256 id) external view returns (PrivacyEntry memory) {
        return privacies[id];
    }
}
