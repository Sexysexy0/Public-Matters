// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EmploymentCharter
/// @notice Covenant to safeguard dignified employment,
///         ensuring fair wages, rights, and workforce dignity.
contract EmploymentCharter {
    address public overseer;
    uint256 public charterCount;

    struct Charter {
        uint256 id;
        string principle;   // FairWages, RightsProtection, WorkforceDignity
        string description;
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

    function declareCharter(string calldata principle, string calldata description) external onlyOverseer {
        charterCount++;
        charters[charterCount] = Charter(charterCount, principle, description, block.timestamp);
        emit CharterDeclared(charterCount, principle, description);
    }

    function viewCharter(uint256 id) external view returns (Charter memory) {
        return charters[id];
    }
}
