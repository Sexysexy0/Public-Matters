// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ETFLiquidityDepthCodex {
    address public steward;

    struct DepthEntry {
        string ETFName;
        string liquidityMetric;
        string depthSignal;
        string emotionalTag;
    }

    DepthEntry[] public codex;

    event ETFLiquidityDepthTagged(string ETFName, string liquidityMetric, string depthSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagDepth(
        string memory ETFName,
        string memory liquidityMetric,
        string memory depthSignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(DepthEntry(ETFName, liquidityMetric, depthSignal, emotionalTag));
        emit ETFLiquidityDepthTagged(ETFName, liquidityMetric, depthSignal, emotionalTag);
    }
}
