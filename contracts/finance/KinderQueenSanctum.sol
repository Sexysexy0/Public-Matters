// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract KinderQueenSanctum {
    struct Sanctum {
        address steward;
        string name;
        string location;
        uint256 joyAPR;
        bool evictionShield;
        bool active;
    }

    Sanctum[] public sanctums;

    event SanctumBlessed(address steward, string name, string location, uint256 joyAPR);
    event EvictionShieldActivated(address steward, string name);

    function blessSanctum(
        address _steward,
        string memory _name,
        string memory _location,
        uint256 _joyAPR
    ) public {
        sanctums.push(Sanctum(_steward, _name, _location, _joyAPR, false, true));
        emit SanctumBlessed(_steward, _name, _location, _joyAPR);
    }

    function activateEvictionShield(uint256 _index) public {
        require(_index < sanctums.length, "Invalid index");
        Sanctum storage s = sanctums[_index];
        require(msg.sender == s.steward, "Not authorized");
        s.evictionShield = true;
        emit EvictionShieldActivated(s.steward, s.name);
    }

    function getAllSanctums() public view returns (Sanctum[] memory) {
        return sanctums;
    }
}
