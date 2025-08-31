// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ScholarProgressTracker {
    struct Progress {
        string scholarName;
        string focusArea;
        string breakthrough;
        uint256 emotionalAPR;
        bool burnoutRisk;
        uint256 timestamp;
        address steward;
    }

    Progress[] public logs;

    event BreakthroughLogged(string scholarName, string focusArea, string breakthrough, uint256 emotionalAPR, bool burnoutRisk);

    function logProgress(
        string memory scholarName,
        string memory focusArea,
        string memory breakthrough,
        uint256 emotionalAPR,
        bool burnoutRisk
    ) public {
        logs.push(Progress(scholarName, focusArea, breakthrough, emotionalAPR, burnoutRisk, block.timestamp, msg.sender));
        emit BreakthroughLogged(scholarName, focusArea, breakthrough, emotionalAPR, burnoutRisk);
    }

    function getAllLogs() public view returns (Progress[] memory) {
        return logs;
    }
}
