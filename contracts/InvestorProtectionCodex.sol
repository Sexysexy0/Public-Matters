// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InvestorProtectionCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of investor protection safeguards
contract InvestorProtectionCodex {
    address public overseer;
    uint256 public protectionCount;

    struct ProtectionEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => ProtectionEntry) public protections;

    event ProtectionLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logProtection(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        protectionCount++;
        protections[protectionCount] = ProtectionEntry({
            id: protectionCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit ProtectionLogged(protectionCount, actor, context);
    }

    function viewProtection(uint256 id) external view returns (ProtectionEntry memory) {
        return protections[id];
    }
}
