// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract SanctumShiftRegistry {
    struct Sanctum {
        string name;
        string location;
        string reason;
        uint256 timestamp;
        address steward;
    }

    Sanctum[] public shifts;

    event SanctumShifted(string name, string location, string reason, address indexed steward);

    function logShift(string memory name, string memory location, string memory reason) public {
        shifts.push(Sanctum(name, location, reason, block.timestamp, msg.sender));
        emit SanctumShifted(name, location, reason, msg.sender);
    }

    function getAllShifts() public view returns (Sanctum[] memory) {
        return shifts;
    }
}
