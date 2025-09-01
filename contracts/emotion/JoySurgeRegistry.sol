// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract JoySurgeRegistry {
    struct JoyScroll {
        string name;
        string region;
        string source; // e.g. "Festival", "Victory", "Healing Ritual"
        uint256 timestamp;
        uint256 joyIndex; // 0–100 scale
        string celebrationTag; // e.g. "Barangay Triumph", "Ancestral Blessing"
        bool broadcasted;
    }

    JoyScroll[] public scrolls;
    address public steward;

    event JoyScrollLogged(string name, string region, string source, uint256 joyIndex);
    event JoyBroadcastActivated(string name, string region);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized joycaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logJoyScroll(
        string memory _name,
        string memory _region,
        string memory _source,
        uint256 _joyIndex,
        string memory _celebrationTag
    ) external onlySteward {
        scrolls.push(JoyScroll(_name, _region, _source, block.timestamp, _joyIndex, _celebrationTag, false));
        emit JoyScrollLogged(_name, _region, _source, _joyIndex);
    }

    function activateBroadcast(uint256 _scrollId) external onlySteward {
        require(_scrollId < scrolls.length, "Invalid scroll ID");
        scrolls[_scrollId].broadcasted = true;
        emit JoyBroadcastActivated(scrolls[_scrollId].name, scrolls[_scrollId].region);
    }

    function getScroll(uint256 _scrollId) external view returns (JoyScroll memory) {
        return scrolls[_scrollId];
    }

    function getScrollCount() external view returns (uint256) {
        return scrolls.length;
    }
}
