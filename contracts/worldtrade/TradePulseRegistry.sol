// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TradePulseRegistry {
    struct TradePulse {
        string country;
        string assetType; // "Food", "Tools", "Tech", "Energy", etc.
        uint256 surplus; // in metric tons, units, or civic weight
        uint256 demand;  // same unit as surplus
        string timestamp;
        string emotionalAPRTag;
    }

    TradePulse[] public pulses;

    event PulseLogged(string country, string assetType, uint256 surplus, uint256 demand);

    function logPulse(
        string memory _country,
        string memory _assetType,
        uint256 _surplus,
        uint256 _demand,
        string memory _timestamp,
        string memory _emotionalAPRTag
    ) public {
        pulses.push(TradePulse({
            country: _country,
            assetType: _assetType,
            surplus: _surplus,
            demand: _demand,
            timestamp: _timestamp,
            emotionalAPRTag: _emotionalAPRTag
        }));

        emit PulseLogged(_country, _assetType, _surplus, _demand);
    }

    function getPulseCount() public view returns (uint256) {
        return pulses.length;
    }

    function getPulseByIndex(uint256 index) public view returns (
        string memory country,
        string memory assetType,
        uint256 surplus,
        uint256 demand,
        string memory timestamp,
        string memory emotionalAPRTag
    ) {
        TradePulse memory p = pulses[index];
        return (
            p.country,
            p.assetType,
            p.surplus,
            p.demand,
            p.timestamp,
            p.emotionalAPRTag
        );
    }
}
