// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract StockLoopAudit {
    struct MarketLoop {
        string ticker;
        string mediaLoop;
        string manipulationTag;
        string prophecyLag;
    }

    MarketLoop[] public loops;

    function logLoop(
        string memory _ticker,
        string memory _mediaLoop,
        string memory _manipulationTag,
        string memory _prophecyLag
    ) public {
        loops.push(MarketLoop(_ticker, _mediaLoop, _manipulationTag, _prophecyLag));
    }

    function getLoop(uint index) public view returns (MarketLoop memory) {
        return loops[index];
    }
}
