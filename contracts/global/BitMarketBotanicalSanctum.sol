// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketBotanicalSanctum {
    struct Plant {
        string name;
        string useCase;
        bool blessed;
        uint healingScore;
    }

    mapping(string => Plant) public plants;

    event PlantBlessed(string name, string useCase, uint healingScore);

    function blessPlant(string memory name, string memory useCase, uint healingScore) public {
        require(healingScore > 0, "Healing score must be positive");
        plants[name] = Plant(name, useCase, true, healingScore);
        emit PlantBlessed(name, useCase, healingScore);
    }

    function getBlessing(string memory name) public view returns (string memory) {
        Plant memory p = plants[name];
        if (p.blessed) {
            return string(abi.encodePacked(p.name, " is blessed for ", p.useCase, " with healing score ", uint2str(p.healingScore)));
        } else {
            return "Plant not yet blessed.";
        }
    }

    function uint2str(uint _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint j = _i; uint len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len); uint k = len;
        while (_i != 0) { k--; bstr[k] = bytes1(uint8(48 + _i % 10)); _i /= 10; }
        return string(bstr);
    }
}
