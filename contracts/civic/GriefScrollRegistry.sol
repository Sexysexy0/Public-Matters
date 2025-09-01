// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GriefScrollRegistry {
    struct GriefScroll {
        string name;
        string region;
        string cause; // e.g. "Flood", "Outbreak", "Violence", "Natural Causes"
        uint256 timestamp;
        uint256 griefIndex; // 0–100 scale
        string memorialTag; // e.g. "Barangay Hero", "Ancestral Guardian"
        bool damayActivated;
    }

    GriefScroll[] public scrolls;
    address public steward;

    event GriefScrollLogged(string name, string region, string cause, uint256 griefIndex);
    event DamayClauseActivated(string name, string region);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logGriefScroll(
        string memory _name,
        string memory _region,
        string memory _cause,
        uint256 _griefIndex,
        string memory _memorialTag
    ) external onlySteward {
        scrolls.push(GriefScroll(_name, _region, _cause, block.timestamp, _griefIndex, _memorialTag, false));
        emit GriefScrollLogged(_name, _region, _cause, _griefIndex);
    }

    function activateDamayClause(uint256 _scrollId) external onlySteward {
        require(_scrollId < scrolls.length, "Invalid scroll ID");
        scrolls[_scrollId].damayActivated = true;
        emit DamayClauseActivated(scrolls[_scrollId].name, scrolls[_scrollId].region);
    }

    function getScroll(uint256 _scrollId) external view returns (GriefScroll memory) {
        return scrolls[_scrollId];
    }

    function getScrollCount() external view returns (uint256) {
        return scrolls.length;
    }
}
