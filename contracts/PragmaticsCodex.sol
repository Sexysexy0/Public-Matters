// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PragmaticsCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of pragmatic safeguards
contract PragmaticsCodex {
    address public overseer;
    uint256 public pragmaticCount;

    struct PragmaticRule {
        uint256 id;
        string principle; // Speech Acts, Implicature, Contextual Meaning, Conversational Maxims
        string description; // encoded pragmatic form
        uint256 timestamp;
    }

    mapping(uint256 => PragmaticRule) public pragmatics;

    event PragmaticLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logPragmatic(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        pragmaticCount++;
        pragmatics[pragmaticCount] = PragmaticRule({
            id: pragmaticCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit PragmaticLogged(pragmaticCount, principle, description);
    }

    function viewPragmatic(uint256 id) external view returns (PragmaticRule memory) {
        return pragmatics[id];
    }
}
