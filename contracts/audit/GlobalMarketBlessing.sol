// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./EmotionalAPR.sol";
import "./SanctumRegistry.sol";
import "./GeoSanctionOracle.sol";

contract GlobalMarketBlessing {
    address public steward;
    mapping(string => bool) public blessedSanctums;
    mapping(string => bool) public frozenSanctums;

    event SanctumBlessed(string sanctum);
    event SanctumFrozen(string sanctum);
    event MarketAccessRequested(string sanctum, bool approved, uint emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        // Pre-freeze rogue sanctums
        frozenSanctums["Russia"] = true;
        frozenSanctums["China"] = true;
    }

    function blessSanctum(string memory sanctum) public onlySteward {
        blessedSanctums[sanctum] = true;
        frozenSanctums[sanctum] = false;
        emit SanctumBlessed(sanctum);
    }

    function freezeSanctum(string memory sanctum) public onlySteward {
        blessedSanctums[sanctum] = false;
        frozenSanctums[sanctum] = true;
        emit SanctumFrozen(sanctum);
    }

    function requestMarketAccess(string memory sanctum, string memory treatyHash) public returns (bool) {
        uint apr = EmotionalAPR.calculate(treatyHash);
        bool geoClear = !GeoSanctionOracle.isSanctioned(sanctum);
        bool approved = blessedSanctums[sanctum] && geoClear && apr >= 75;

        emit MarketAccessRequested(sanctum, approved, apr);
        return approved;
    }
}
