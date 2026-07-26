// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CosmicAlignmentBridge {
    struct Alignment {
        address participant;
        string celestialEvent;
        uint256 timestamp;
        bool safeguarded;
    }

    Alignment[] public alignments;

    event AlignmentLogged(address indexed participant, string celestialEvent);
    event AlignmentSafeguarded(uint256 indexed id, address verifier);

    function logAlignment(string memory _celestialEvent) public {
        alignments.push(Alignment(msg.sender, _celestialEvent, block.timestamp, false));
        emit AlignmentLogged(msg.sender, _celestialEvent);
    }

    function safeguardAlignment(uint256 _id) public {
        require(_id < alignments.length, "Invalid ID");
        alignments[_id].safeguarded = true;
        emit AlignmentSafeguarded(_id, msg.sender);
    }

    function getAlignment(uint256 _id) public view returns (Alignment memory) {
        require(_id < alignments.length, "Invalid ID");
        return alignments[_id];
    }

    function totalAlignments() public view returns (uint256) {
        return alignments.length;
    }
}
