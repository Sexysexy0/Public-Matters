// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MedicalAccountabilityCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of medical accountability safeguards
contract MedicalAccountabilityCodex {
    address public overseer;
    uint256 public accountabilityCount;

    struct AccountabilityEntry {
        uint256 id;
        string actor;
        string procedure;
        string responsibility;
        uint256 timestamp;
    }

    mapping(uint256 => AccountabilityEntry) public accountabilities;

    event AccountabilityLogged(uint256 indexed id, string actor, string procedure, string responsibility);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAccountability(
        string calldata actor,
        string calldata procedure,
        string calldata responsibility
    ) external onlyOverseer {
        accountabilityCount++;
        accountabilities[accountabilityCount] = AccountabilityEntry({
            id: accountabilityCount,
            actor: actor,
            procedure: procedure,
            responsibility: responsibility,
            timestamp: block.timestamp
        });
        emit AccountabilityLogged(accountabilityCount, actor, procedure, responsibility);
    }

    function viewAccountability(uint256 id) external view returns (AccountabilityEntry memory) {
        return accountabilities[id];
    }
}
