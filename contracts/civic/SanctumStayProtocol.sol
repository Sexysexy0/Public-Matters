// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SanctumStayProtocol {
    struct StayLog {
        string mentorName;
        string originSanctum;
        uint256 arrivalTimestamp;
        uint256 departureTimestamp;
        string emotionalResonance;
        string civicImpact;
        address steward;
    }

    StayLog[] public stays;

    event StayLogged(string mentorName, string emotionalResonance, string civicImpact);

    function logStay(
        string memory mentorName,
        string memory originSanctum,
        uint256 arrivalTimestamp,
        uint256 departureTimestamp,
        string memory emotionalResonance,
        string memory civicImpact
    ) public {
        stays.push(StayLog(mentorName, originSanctum, arrivalTimestamp, departureTimestamp, emotionalResonance, civicImpact, msg.sender));
        emit StayLogged(mentorName, emotionalResonance, civicImpact);
    }

    function getAllStays() public view returns (StayLog[] memory) {
        return stays;
    }
}
