// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ETFLiquidityProtocol {
    address public steward;

    struct LiquidityEntry {
        string ETFName;
        string capitalSource;
        string liquidityImpact;
        string emotionalTag;
    }

    LiquidityEntry[] public registry;

    event ETFLiquidityTagged(string ETFName, string capitalSource, string liquidityImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagLiquidity(
        string memory ETFName,
        string memory capitalSource,
        string memory liquidityImpact,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(LiquidityEntry(ETFName, capitalSource, liquidityImpact, emotionalTag));
        emit ETFLiquidityTagged(ETFName, capitalSource, liquidityImpact, emotionalTag);
    }
}
