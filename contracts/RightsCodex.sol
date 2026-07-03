// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RightsCodex
/// @notice Covenant contract to symbolically safeguard civil rights, human dignity, and justice equity
contract RightsCodex {
    address public overseer;
    uint256 public rightsCount;

    struct RightsRule {
        uint256 id;
        string principle; // Civil Rights, Human Dignity, Bail Fairness, Justice Equity
        string description; // encoded rights safeguard
        uint256 timestamp;
    }

    mapping(uint256 => RightsRule) public rights;

    event RightsLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRights(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        rightsCount++;
        rights[rightsCount] = RightsRule({
            id: rightsCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit RightsLogged(rightsCount, principle, description);
    }

    function viewRights(uint256 id) external view returns (RightsRule memory) {
        return rights[id];
    }
}
