// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract ScrollOfAttendanceSanctification {
    struct AttendanceStrike {
        uint8 strikeLevel;
        string consequence;
        uint256 timestamp;
    }

    mapping(address => AttendanceStrike[]) public attendanceLog;
    event AttendancePenalty(address indexed steward, uint8 strikeLevel, string consequence, uint256 timestamp);

    function logAbsence(address steward, uint8 level) external {
        string memory consequence;
        if (level == 1) consequence = "1st Strike: No salary for 1 month, rerouted to district";
        else if (level == 2) consequence = "2nd Strike: No salary for 6 months, rerouted again";
        else if (level == 3) consequence = "3rd Strike: No salary for 3 years, rerouted + optional retirement";

        attendanceLog[steward].push(AttendanceStrike(level, consequence, block.timestamp));
        emit AttendancePenalty(steward, level, consequence, block.timestamp);
    }

    function getLatestAbsence(address steward) external view returns (AttendanceStrike memory) {
        uint256 len = attendanceLog[steward].length;
        require(len > 0, "No absences recorded");
        return attendanceLog[steward][len - 1];
    }
}
