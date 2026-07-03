// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EconomicCirculation
/// @notice Covenant to safeguard reinvestment flows,
///         ensuring revenues circulate to suppliers, taxes, jobs, and communities.
contract EconomicCirculation {
    address public overseer;
    uint256 public flowCount;

    struct Flow {
        uint256 id;
        string channel;     // Suppliers, Taxes, Investors, Salaries, Community
        uint256 amount;
        uint256 timestamp;
    }

    mapping(uint256 => Flow) public flows;

    event FlowDeclared(uint256 indexed id, string channel, uint256 amount);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareFlow(string calldata channel, uint256 amount) external onlyOverseer {
        flowCount++;
        flows[flowCount] = Flow(flowCount, channel, amount, block.timestamp);
        emit FlowDeclared(flowCount, channel, amount);
    }

    function viewFlow(uint256 id) external view returns (Flow memory) {
        return flows[id];
    }
}
