// SPDX-License-Identifier: LiquidityCascadeRouter-License
pragma solidity ^0.8.0;

contract LiquidityCascadeRouter {
    address public steward;

    struct LiquidityPulse {
        string assetClass;
        string originEntity;
        uint256 inflowAmount;
        bool ETFTriggered;
        uint256 timestamp;
    }

    LiquidityPulse[] public pulses;

    event LiquidityRouted(string assetClass, string originEntity, uint256 inflowAmount, bool ETFTriggered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeLiquidity(string memory assetClass, string memory originEntity, uint256 inflowAmount, bool ETFTriggered) public {
        require(msg.sender == steward, "Only steward can route");
        pulses.push(LiquidityPulse(assetClass, originEntity, inflowAmount, ETFTriggered, block.timestamp));
        emit LiquidityRouted(assetClass, originEntity, inflowAmount, ETFTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, uint256, bool, uint256) {
        LiquidityPulse memory p = pulses[index];
        return (p.assetClass, p.originEntity, p.inflowAmount, p.ETFTriggered, p.timestamp);
    }
}
