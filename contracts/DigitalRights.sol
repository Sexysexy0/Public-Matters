// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DigitalRights
/// @notice Covenant to safeguard digital dignity,
///         ensuring privacy, freedom of expression, and equitable access.
contract DigitalRights {
    address public overseer;
    uint256 public rightsCount;

    struct Right {
        uint256 id;
        string principle;   // Privacy, FreedomOfExpression, EquitableAccess
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Right) public rights;

    event RightDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareRight(string calldata principle, string calldata description) external onlyOverseer {
        rightsCount++;
        rights[rightsCount] = Right(rightsCount, principle, description, block.timestamp);
        emit RightDeclared(rightsCount, principle, description);
    }

    function viewRight(uint256 id) external view returns (Right memory) {
        return rights[id];
    }
}
