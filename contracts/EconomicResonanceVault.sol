// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EconomicResonanceVault {
    struct Shift {
        address participant;
        string factor;
        uint256 timestamp;
        bool safeguarded;
    }

    Shift[] public shifts;

    event ShiftLogged(address indexed participant, string factor);
    event ShiftSafeguarded(uint256 indexed id, address verifier);

    function logShift(string memory _factor) public {
        shifts.push(Shift(msg.sender, _factor, block.timestamp, false));
        emit ShiftLogged(msg.sender, _factor);
    }

    function safeguardShift(uint256 _id) public {
        require(_id < shifts.length, "Invalid ID");
        shifts[_id].safeguarded = true;
        emit ShiftSafeguarded(_id, msg.sender);
    }

    function getShift(uint256 _id) public view returns (Shift memory) {
        require(_id < shifts.length, "Invalid ID");
        return shifts[_id];
    }

    function totalShifts() public view returns (uint256) {
        return shifts.length;
    }
}
