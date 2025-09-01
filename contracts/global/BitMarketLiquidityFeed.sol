// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketLiquidityFeed {
    struct LiquiditySignal {
        string asset;
        uint256 emotionalAPR;
        uint256 tradeVolume;
        string vendorTag;
        uint256 timestamp;
    }

    LiquiditySignal[] public signals;

    event SignalLogged(string asset, uint256 emotionalAPR, uint256 tradeVolume, string vendorTag);

    function logSignal(
        string memory _asset,
        uint256 _emotionalAPR,
        uint256 _tradeVolume,
        string memory _vendorTag
    ) public {
        signals.push(LiquiditySignal(_asset, _emotionalAPR, _tradeVolume, _vendorTag, block.timestamp));
        emit SignalLogged(_asset, _emotionalAPR, _tradeVolume, _vendorTag);
    }

    function getSignals() public view returns (LiquiditySignal[] memory) {
        return signals;
    }
}
