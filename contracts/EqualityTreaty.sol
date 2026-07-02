// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EqualityTreaty
/// @notice Covenant contract to safeguard equal rights and dignified treatment,
///         ensuring fairness, inclusion, and balance in governance.
contract EqualityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct Treaty {
        uint256 id;
        string principle;   // EqualRights, Inclusion, Fairness, Balance
        string description; // Encoded safeguard
        uint256 timestamp;
    }

    mapping(uint256 => Treaty) public treaties;

    event TreatyDeclared(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function declareTreaty(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = Treaty({
            id: treatyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit TreatyDeclared(treatyCount, principle, description);
    }

    function viewTreaty(uint256 id) external view returns (Treaty memory) {
        return treaties[id];
    }
}
