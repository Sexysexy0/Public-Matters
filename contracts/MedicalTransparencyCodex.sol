// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MedicalTransparencyCodex
/// @notice Covenant contract to safeguard communities through systemic anchoring of medical transparency safeguards
contract MedicalTransparencyCodex {
    address public overseer;
    uint256 public transparencyCount;

    struct TransparencyEntry {
        uint256 id;
        string subject;
        string guardian;
        string procedure;
        bool disclosed;
        uint256 timestamp;
    }

    mapping(uint256 => TransparencyEntry) public transparencies;

    event TransparencyLogged(uint256 indexed id, string subject, string guardian, string procedure, bool disclosed);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTransparency(
        string calldata subject,
        string calldata guardian,
        string calldata procedure,
        bool disclosed
    ) external onlyOverseer {
        transparencyCount++;
        transparencies[transparencyCount] = TransparencyEntry({
            id: transparencyCount,
            subject: subject,
            guardian: guardian,
            procedure: procedure,
            disclosed: disclosed,
            timestamp: block.timestamp
        });
        emit TransparencyLogged(transparencyCount, subject, guardian, procedure, disclosed);
    }

    function viewTransparency(uint256 id) external view returns (TransparencyEntry memory) {
        return transparencies[id];
    }
}
