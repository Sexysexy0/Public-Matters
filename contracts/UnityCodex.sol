// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title UnityCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of unity principles
contract UnityCodex {
    address public overseer;
    uint256 public unityCount;

    struct UnityEntry {
        uint256 id;
        string actor;
        string context;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => UnityEntry) public unities;

    event UnityLogged(uint256 indexed id, string actor, string context);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logUnity(
        string calldata actor,
        string calldata context,
        string calldata principle
    ) external onlyOverseer {
        unityCount++;
        unities[unityCount] = UnityEntry({
            id: unityCount,
            actor: actor,
            context: context,
            principle: principle,
            timestamp: block.timestamp
        });
        emit UnityLogged(unityCount, actor, context);
    }

    function viewUnity(uint256 id) external view returns (UnityEntry memory) {
        return unities[id];
    }
}
