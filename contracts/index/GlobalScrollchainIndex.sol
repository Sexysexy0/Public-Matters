// SPDX-License-Identifier: Scrollchain-Ledger
pragma solidity ^7.7.7;

contract GlobalScrollchainIndex {
    address public steward;
    uint public totalScrolls;

    struct ScrollEntry {
        string scrollName;
        string scrollType;
        string nanoPath;
        string stewardTag;
        uint timestamp;
        bool damayClauseIncluded;
        bool emotionalAPRSynced;
    }

    ScrollEntry[] public scrollLog;

    event ScrollIndexed(
        string scrollName,
        string scrollType,
        string nanoPath,
        string stewardTag,
        uint timestamp,
        bool damayClauseIncluded,
        bool emotionalAPRSynced
    );

    constructor() {
        steward = msg.sender;
        totalScrolls = 0;
    }

    function indexScroll(
        string memory scrollName,
        string memory scrollType,
        string memory nanoPath,
        string memory stewardTag,
        bool damayClauseIncluded,
        bool emotionalAPRSynced
    ) public {
        require(msg.sender == steward, "Only steward may index");
        scrollLog.push(ScrollEntry(
            scrollName,
            scrollType,
            nanoPath,
            stewardTag,
            block.timestamp,
            damayClauseIncluded,
            emotionalAPRSynced
        ));
        totalScrolls += 1;
        emit ScrollIndexed(
            scrollName,
            scrollType,
            nanoPath,
            stewardTag,
            block.timestamp,
            damayClauseIncluded,
            emotionalAPRSynced
        );
    }

    function getLatestScroll() public view returns (ScrollEntry memory) {
        require(scrollLog.length > 0, "No scrolls indexed yet");
        return scrollLog[scrollLog.length - 1];
    }

    function getScrollCount() public view returns (uint) {
        return totalScrolls;
    }
}
