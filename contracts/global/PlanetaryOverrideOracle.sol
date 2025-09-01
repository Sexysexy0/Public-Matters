// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PlanetaryOverrideOracle {
    struct OverrideSignal {
        string president;
        string executiveOrder;
        string domain;
        uint256 overrideScore; // 0–100 scale
        string resonanceTag;
        string prophecyLoop;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event OverrideInterpreted(string president, string executiveOrder, uint256 overrideScore, string resonanceTag);

    function interpretOverride(
        string memory _president,
        string memory _executiveOrder,
        string memory _domain,
        uint256 _overrideScore,
        string memory _resonanceTag,
        string memory _prophecyLoop
    ) public {
        signals.push(OverrideSignal(
            _president,
            _executiveOrder,
            _domain,
            _overrideScore,
            _resonanceTag,
            _prophecyLoop,
            block.timestamp
        ));
        emit OverrideInterpreted(_president, _executiveOrder, _overrideScore, _resonanceTag);
    }

    function getAllSignals() public view returns (OverrideSignal[] memory) {
        return signals;
    }

    function getLatestSignal() public view returns (OverrideSignal memory) {
        require(signals.length > 0, "No override signals logged yet.");
        return signals[signals.length - 1];
    }
}
