// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityRightsCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of community rights safeguards
contract CommunityRightsCodex {
    address public overseer;
    uint256 public rightsCount;

    struct RightsEntry {
        uint256 id;
        string community;
        string representative;
        string right;
        uint256 timestamp;
    }

    mapping(uint256 => RightsEntry) public rights;

    event RightsLogged(uint256 indexed id, string community, string representative, string right);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRight(
        string calldata community,
        string calldata representative,
        string calldata right
    ) external onlyOverseer {
        rightsCount++;
        rights[rightsCount] = RightsEntry({
            id: rightsCount,
            community: community,
            representative: representative,
            right: right,
            timestamp: block.timestamp
        });
        emit RightsLogged(rightsCount, community, representative, right);
    }

    function viewRight(uint256 id) external view returns (RightsEntry memory) {
        return rights[id];
    }
}
