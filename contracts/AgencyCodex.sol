// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AgencyCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of agency safeguards
contract AgencyCodex {
    address public overseer;
    uint256 public agencyCount;

    struct AgencyRule {
        uint256 id;
        string principle; // Self-Determination, Autonomy, Choice, Responsibility
        string description; // encoded agency form
        uint256 timestamp;
    }

    mapping(uint256 => AgencyRule) public agencies;

    event AgencyLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAgency(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        agencyCount++;
        agencies[agencyCount] = AgencyRule({
            id: agencyCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit AgencyLogged(agencyCount, principle, description);
    }

    function viewAgency(uint256 id) external view returns (AgencyRule memory) {
        return agencies[id];
    }
}
