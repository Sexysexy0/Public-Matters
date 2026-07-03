// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FamilyRightsBridge
/// @notice Covenant contract to safeguard communities through systemic anchoring of family rights safeguards
contract FamilyRightsBridge {
    address public overseer;
    uint256 public rightsCount;

    struct RightsEntry {
        uint256 id;
        string child;
        string guardian;
        string right;
        uint256 timestamp;
    }

    mapping(uint256 => RightsEntry) public rights;

    event RightsLogged(uint256 indexed id, string child, string guardian, string right);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRight(
        string calldata child,
        string calldata guardian,
        string calldata right
    ) external onlyOverseer {
        rightsCount++;
        rights[rightsCount] = RightsEntry({
            id: rightsCount,
            child: child,
            guardian: guardian,
            right: right,
            timestamp: block.timestamp
        });
        emit RightsLogged(rightsCount, child, guardian, right);
    }

    function viewRight(uint256 id) external view returns (RightsEntry memory) {
        return rights[id];
    }
}
