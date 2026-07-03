// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PatientRightsCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of patient rights safeguards
contract PatientRightsCodex {
    address public overseer;
    uint256 public rightsCount;

    struct RightsEntry {
        uint256 id;
        string patient;
        string guardian;
        string right;
        uint256 timestamp;
    }

    mapping(uint256 => RightsEntry) public rights;

    event RightsLogged(uint256 indexed id, string patient, string guardian, string right);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logRight(
        string calldata patient,
        string calldata guardian,
        string calldata right
    ) external onlyOverseer {
        rightsCount++;
        rights[rightsCount] = RightsEntry({
            id: rightsCount,
            patient: patient,
            guardian: guardian,
            right: right,
            timestamp: block.timestamp
        });
        emit RightsLogged(rightsCount, patient, guardian, right);
    }

    function viewRight(uint256 id) external view returns (RightsEntry memory) {
        return rights[id];
    }
}
