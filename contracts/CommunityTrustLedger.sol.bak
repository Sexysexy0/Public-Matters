// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityTrustLedger {
    struct Entry {
        address contributor;
        string project;
        uint256 timestamp;
        bool trusted;
    }

    Entry[] public entries;

    event EntryLogged(address indexed contributor, string project);
    event EntryTrusted(uint256 indexed id, address verifier);

    function logEntry(string memory _project) public {
        entries.push(Entry(msg.sender, _project, block.timestamp, false));
        emit EntryLogged(msg.sender, _project);
    }

    function markTrusted(uint256 _id) public {
        require(_id < entries.length, "Invalid ID");
        entries[_id].trusted = true;
        emit EntryTrusted(_id, msg.sender);
    }

    function getEntry(uint256 _id) public view returns (Entry memory) {
        require(_id < entries.length, "Invalid ID");
        return entries[_id];
    }

    function totalEntries() public view returns (uint256) {
        return entries.length;
    }
}
