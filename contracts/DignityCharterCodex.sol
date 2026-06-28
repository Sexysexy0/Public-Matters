// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DignityCharterCodex
/// @notice Covenant contract to safeguard communities through systemic protection of human dignity
contract DignityCharterCodex {
    address public overseer;
    uint256 public charterCount;

    struct CharterEntry {
        uint256 id;
        string principle;
        string application;
        uint256 timestamp;
    }

    mapping(uint256 => CharterEntry) public charters;

    event CharterLogged(uint256 indexed id, string principle, string application);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCharter(
        string calldata principle,
        string calldata application
    ) external onlyOverseer {
        charterCount++;
        charters[charterCount] = CharterEntry({
            id: charterCount,
            principle: principle,
            application: application,
            timestamp: block.timestamp
        });
        emit CharterLogged(charterCount, principle, application);
    }

    function viewCharter(uint256 id) external view returns (CharterEntry memory) {
        return charters[id];
    }
}
