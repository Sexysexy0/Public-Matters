// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MentalHealthSupportCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of mental health support safeguards
contract MentalHealthSupportCodex {
    address public overseer;
    uint256 public supportCount;

    struct SupportEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => SupportEntry) public supports;

    event SupportLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSupport(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        supportCount++;
        supports[supportCount] = SupportEntry({
            id: supportCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit SupportLogged(supportCount, actor, context);
    }

    function viewSupport(uint256 id) external view returns (SupportEntry memory) {
        return supports[id];
    }
}
