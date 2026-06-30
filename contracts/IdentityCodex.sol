// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IdentityCodex
/// @notice Covenant contract to safeguard leadership and projects through systemic anchoring of identity, representation, and authorship
contract IdentityCodex {
    address public overseer;
    uint256 public identityCount;

    struct IdentityRule {
        uint256 id;
        string principle; // Representation, Authorship, Authenticity, Recognition
        string description; // encoded identity safeguard
        uint256 timestamp;
    }

    mapping(uint256 => IdentityRule) public identities;

    event IdentityLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logIdentity(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        identityCount++;
        identities[identityCount] = IdentityRule({
            id: identityCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit IdentityLogged(identityCount, principle, description);
    }

    function viewIdentity(uint256 id) external view returns (IdentityRule memory) {
        return identities[id];
    }
}
