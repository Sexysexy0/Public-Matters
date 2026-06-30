// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AdvocacyCodex
/// @notice Covenant contract to symbolically safeguard organized lobbying, policy influence, and systemic advocacy
contract AdvocacyCodex {
    address public overseer;
    uint256 public advocacyCount;

    struct AdvocacyRule {
        uint256 id;
        string principle; // Lobbying, Policy Influence, Collective Advocacy, Legislative Reform
        string description; // encoded advocacy safeguard
        uint256 timestamp;
    }

    mapping(uint256 => AdvocacyRule) public advocacies;

    event AdvocacyLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAdvocacy(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        advocacyCount++;
        advocacies[advocacyCount] = AdvocacyRule({
            id: advocacyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit AdvocacyLogged(advocacyCount, principle, description);
    }

    function viewAdvocacy(uint256 id) external view returns (AdvocacyRule memory) {
        return advocacies[id];
    }
}
