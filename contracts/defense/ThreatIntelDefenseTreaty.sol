// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ThreatIntelDefenseTreaty {
    struct Defender {
        string name;
        bool isActive;
        bool isUnderThreat;
        bool isProtected;
    }

    mapping(address => Defender) public defenders;

    function registerDefender(
        address _defender,
        string memory _name,
        bool _isActive,
        bool _isUnderThreat
    ) public {
        defenders[_defender] = Defender(_name, _isActive, _isUnderThreat, true);
    }

    function revokeThreat(address _defender) public {
        defenders[_defender].isUnderThreat = false;
    }

    function isProtected(address _defender) public view returns (bool) {
        return defenders[_defender].isProtected && defenders[_defender].isActive;
    }
}
