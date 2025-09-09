// SPDX-License-Identifier: DigitalTengeLiquidity-License
pragma solidity ^0.8.0;

contract DigitalTengeLiquidityOracle {
    address public steward;

    struct LiquidityPulse {
        string asset;
        string protocol;
        string eventType;
        bool reserveActivated;
        uint256 timestamp;
    }

    LiquidityPulse[] public pulses;

    event LiquidityPulseEmitted(string asset, string protocol, string eventType, bool reserve, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory asset, string memory protocol, string memory eventType, bool reserveActivated) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(LiquidityPulse(asset, protocol, eventType, reserveActivated, block.timestamp));
        emit LiquidityPulseEmitted(asset, protocol, eventType, reserveActivated, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        LiquidityPulse memory p = pulses[index];
        return (p.asset, p.protocol, p.eventType, p.reserveActivated, p.timestamp);
    }
}
