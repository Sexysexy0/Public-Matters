// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CharityCodex
/// @notice Covenant contract to safeguard systemic generosity, principled charity, and dignified giving
contract CharityCodex {
    address public overseer;
    uint256 public charityCount;

    struct CharityRule {
        uint256 id;
        string principle; // Generosity, Kindness, Service, Giving
        string description; // encoded charity safeguard
        uint256 timestamp;
    }

    mapping(uint256 => CharityRule) public charities;

    event CharityLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCharity(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        charityCount++;
        charities[charityCount] = CharityRule({
            id: charityCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit CharityLogged(charityCount, principle, description);
    }

    function viewCharity(uint256 id) external view returns (CharityRule memory) {
        return charities[id];
    }
}
