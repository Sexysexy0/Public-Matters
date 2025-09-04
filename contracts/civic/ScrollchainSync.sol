// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollchainSync {
    struct ScrollLog {
        uint256 timestamp;
        string scrollTitle;
        string emotionalTag;
        address steward;
    }

    ScrollLog[] public logs;

    event ScrollSynced(string title, string tag, address steward);

    function syncScroll(string memory _title, string memory _tag) external {
        logs.push(ScrollLog(block.timestamp, _title, _tag, msg.sender));
        emit ScrollSynced(_title, _tag, msg.sender);
    }

    function getScroll(uint256 _index) external view returns (ScrollLog memory) {
        require(_index < logs.length, "Out of bounds");
        return logs[_index];
    }

    function totalScrolls() external view returns (uint256) {
        return logs.length;
    }
}
