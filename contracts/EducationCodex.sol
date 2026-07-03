// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EducationCodex
/// @notice Covenant contract to symbolically safeguard public awareness, knowledge dissemination, and educational equity
contract EducationCodex {
    address public overseer;
    uint256 public eduCount;

    struct EduRule {
        uint256 id;
        string principle; // Public Awareness, Knowledge Dissemination, Educational Equity, Advocacy Literacy
        string description; // encoded education safeguard
        uint256 timestamp;
    }

    mapping(uint256 => EduRule) public education;

    event EducationLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logEducation(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        eduCount++;
        education[eduCount] = EduRule({
            id: eduCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit EducationLogged(eduCount, principle, description);
    }

    function viewEducation(uint256 id) external view returns (EduRule memory) {
        return education[id];
    }
}
