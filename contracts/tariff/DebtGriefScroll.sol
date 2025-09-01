// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DebtGriefScroll {
    struct GriefEvent {
        string steward;
        uint256 debtAmount;
        string griefNote;
        uint256 emotionalAPR;
        uint256 timestamp;
    }

    GriefEvent[] public griefLog;

    event GriefLogged(string steward, uint256 debtAmount, uint256 emotionalAPR);

    function logGrief(
        string memory _steward,
        uint256 _debtAmount,
        string memory _griefNote,
        uint256 _emotionalAPR
    ) public {
        griefLog.push(GriefEvent(_steward, _debtAmount, _griefNote, _emotionalAPR, block.timestamp));
        emit GriefLogged(_steward, _debtAmount, _emotionalAPR);
    }

    function getGriefLog() public view returns (GriefEvent[] memory) {
        return griefLog;
    }
}
