// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityCharter
/// @notice Covenant contract to safeguard equal opportunity and fairness,
///         ensuring inclusion, justice, and dignity for all.
contract EquityCharter {
    address public overseer;
    uint256 public charterCount;

    struct Charter {
        uint256 id;
        string principle;   // EqualOpportunity, Inclusion, Fairness, Justice
        string description; // Encoded safeguard
        uint256 timestamp;
    }

    mapping(uint256 => Charter) public charters;

    event CharterDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareCharter(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        charterCount++;
        charters[charterCount] = Charter({
            id: charterCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit CharterDeclared(charterCount, principle, description);
    }

    function viewCharter(uint256 id) external view returns (Charter memory) {
        return charters[id];
    }
}
