// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OraclePreservationShield {
    struct Archive {
        address curator;
        string title;
        string medium;
        uint256 timestamp;
        bool safeguarded;
    }

    Archive[] public archives;

    event ArchiveLogged(address indexed curator, string title, string medium);
    event ArchiveSafeguarded(uint256 indexed id, address verifier);

    function logArchive(string memory _title, string memory _medium) public {
        archives.push(Archive(msg.sender, _title, _medium, block.timestamp, false));
        emit ArchiveLogged(msg.sender, _title, _medium);
    }

    function safeguardArchive(uint256 _id) public {
        require(_id < archives.length, "Invalid ID");
        archives[_id].safeguarded = true;
        emit ArchiveSafeguarded(_id, msg.sender);
    }

    function getArchive(uint256 _id) public view returns (Archive memory) {
        require(_id < archives.length, "Invalid ID");
        return archives[_id];
    }

    function totalArchives() public view returns (uint256) {
        return archives.length;
    }
}
