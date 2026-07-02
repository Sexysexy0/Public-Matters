// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RightsRegistry
/// @notice Covenant contract to establish a registry of citizen rights
///         in digital governance systems, ensuring dignity and protections.
contract RightsRegistry {
    address public overseer;
    uint256 public rightsCount;

    struct Right {
        uint256 id;
        string principle;   // Privacy, Consent, Access, Challenge
        string description; // Encoded safeguard
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

    /// @notice Declare a new citizen right safeguard
    function declareRight(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        rightsCount++;
        rights[rightsCount] = Right({
            id: rightsCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit RightDeclared(rightsCount, principle, description);
    }

    /// @notice View a specific citizen right safeguard
    function viewRight(uint256 id) external view returns (Right memory) {
        return rights[id];
    }
}
