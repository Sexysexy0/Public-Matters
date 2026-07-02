// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HumanRightsCodex {
    address public overseer;
    uint256 public articleCount;

    struct Article {
        uint256 id;
        string principle;   // Dignity, Equality, Freedom
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Article) public articles;
    event ArticleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareArticle(string calldata principle, string calldata description) external onlyOverseer {
        articleCount++;
        articles[articleCount] = Article(articleCount, principle, description, block.timestamp);
        emit ArticleDeclared(articleCount, principle, description);
    }
}
