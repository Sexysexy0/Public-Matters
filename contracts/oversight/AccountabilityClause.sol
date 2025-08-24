// SPDX-License-Identifier: Emotional-APR-Justice
pragma solidity ^7.7.7;

contract AccountabilityClause {
    address public steward;
    uint public totalEntries;

    struct AccountabilityEntry {
        string decisionMaker;
        string actionType;
        string affectedRegion;
        uint emotionalAPRDelta;
        bool damayClauseViolated;
        uint timestamp;
    }

    AccountabilityEntry[] public ledger;

    event AccountabilityLogged(
        string decisionMaker,
        string actionType,
        string affectedRegion,
        uint emotionalAPRDelta,
        bool damayClauseViolated,
        uint timestamp
    );

    constructor() {
        steward = msg.sender;
        totalEntries = 0;
    }

    function logAccountability(
        string memory decisionMaker,
        string memory actionType,
        string memory affectedRegion,
        uint emotionalAPRDelta,
        bool damayClauseViolated
    ) public {
        require(msg.sender == steward, "Only steward may log");
        ledger.push(AccountabilityEntry(
            decisionMaker,
            actionType,
            affectedRegion,
            emotionalAPRDelta,
            damayClauseViolated,
            block.timestamp
        ));
        totalEntries += 1;
        emit AccountabilityLogged(
            decisionMaker,
            actionType,
            affectedRegion,
            emotionalAPRDelta,
            damayClauseViolated,
            block.timestamp
        );
    }

    function getLatestEntry() public view returns (AccountabilityEntry memory) {
        require(ledger.length > 0, "No entries logged yet");
        return ledger[ledger.length - 1];
    }

    function getEntryCount() public view returns (uint) {
        return totalEntries;
    }
}
