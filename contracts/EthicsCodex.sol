// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EthicsCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of ethical conduct safeguards
contract EthicsCodex {
    address public overseer;
    uint256 public ethicsCount;

    struct EthicsRule {
        uint256 id;
        string principle; // Integrity, Responsibility, Respect, Professional Conduct
        string description; // encoded ethics form
        uint256 timestamp;
    }

    mapping(uint256 => EthicsRule) public ethicsRules;

    event EthicsLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEthics(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        ethicsCount++;
        ethicsRules[ethicsCount] = EthicsRule({
            id: ethicsCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit EthicsLogged(ethicsCount, principle, description);
    }

    function viewEthics(uint256 id) external view returns (EthicsRule memory) {
        return ethicsRules[id];
    }
}
