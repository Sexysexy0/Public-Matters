// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CommentaryGuard: mark content as opinion/commentary and enforce boundaries
contract CommentaryGuard {
    struct Commentary {
        uint256 id;
        string contentURI;    // video/article
        bool opinion;         // true = opinion, not legal advice
        string basisURI;      // references used (optional)
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Commentary) public commentaries;
    mapping(address => bool) public stewards;

    event CommentarySet(uint256 indexed id, bool opinion);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setCommentary(string calldata contentURI, bool opinion, string calldata basisURI) external {
        require(stewards[msg.sender], "Only steward");
        commentaries[nextId] = Commentary(nextId, contentURI, opinion, basisURI, block.timestamp);
        emit CommentarySet(nextId, opinion);
        nextId++;
    }
}
