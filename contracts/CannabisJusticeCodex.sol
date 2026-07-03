// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CannabisJusticeCodex
/// @notice Covenant contract to symbolically safeguard fairness and justice equity in cannabis policy reform
contract CannabisJusticeCodex {
    address public overseer;
    uint256 public justiceCount;

    struct JusticeRule {
        uint256 id;
        string principle; // Fairness, Decriminalization, Bail Equity, Human Dignity
        string description; // encoded justice safeguard
        uint256 timestamp;
    }

    mapping(uint256 => JusticeRule) public justices;

    event JusticeLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logJustice(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        justiceCount++;
        justices[justiceCount] = JusticeRule({
            id: justiceCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit JusticeLogged(justiceCount, principle, description);
    }

    function viewJustice(uint256 id) external view returns (JusticeRule memory) {
        return justices[id];
    }
}
