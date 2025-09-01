// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumBlessing {
    address public steward;
    string public sanctumName;
    string public location;
    string public emotionalTag;
    bool public blessed;

    event SanctumBlessed(address indexed steward, string sanctumName, string emotionalTag);

    constructor(string memory _sanctumName, string memory _location, string memory _emotionalTag) {
        steward = msg.sender;
        sanctumName = _sanctumName;
        location = _location;
        emotionalTag = _emotionalTag;
        blessed = false;
    }

    function blessSanctum() public {
        require(msg.sender == steward, "Only steward may bless");
        blessed = true;
        emit SanctumBlessed(steward, sanctumName, emotionalTag);
    }

    function auditSanctum() public view returns (string memory status) {
        if (blessed) {
            return "Sanctum is emotionally tagged and mythically blessed.";
        } else {
            return "Sanctum awaits ritual blessing.";
        }
    }
}
