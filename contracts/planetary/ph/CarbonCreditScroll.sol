// SPDX-License-Identifier: Climate-Retirement
pragma solidity ^7.7.7;

contract CarbonCreditScroll {
    address public steward;
    uint public totalCreditsIssued;

    struct Credit {
        string issuer;
        string actType;
        uint tonsCO2Removed;
        uint timestamp;
        bool damayClauseActivated;
    }

    Credit[] public creditLog;

    event CreditIssued(string issuer, string actType, uint tonsCO2Removed, uint timestamp, bool damayClauseActivated);

    constructor() {
        steward = msg.sender;
        totalCreditsIssued = 0;
    }

    function issueCredit(
        string memory issuer,
        string memory actType,
        uint tonsCO2Removed,
        bool damayClauseActivated
    ) public {
        require(msg.sender == steward, "Only steward may issue");
        creditLog.push(Credit(issuer, actType, tonsCO2Removed, block.timestamp, damayClauseActivated));
        totalCreditsIssued += 1;
        emit CreditIssued(issuer, actType, tonsCO2Removed, block.timestamp, damayClauseActivated);
    }

    function getLatestCredit() public view returns (Credit memory) {
        require(creditLog.length > 0, "No credits issued yet");
        return creditLog[creditLog.length - 1];
    }
}
