// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PropheticCorrectionCodex
/// @notice Covenant contract to safeguard communities by balancing prophetic warnings with pastoral corrections
contract PropheticCorrectionCodex {
    address public overseer;
    uint256 public correctionCount;

    struct CorrectionEntry {
        uint256 id;
        string warning;
        string correction;
        string reference;
        uint256 timestamp;
    }

    mapping(uint256 => CorrectionEntry) public corrections;

    event CorrectionLogged(uint256 indexed id, string warning, string correction);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logCorrection(
        string calldata warning,
        string calldata correction,
        string calldata reference
    ) external onlyOverseer {
        correctionCount++;
        corrections[correctionCount] = CorrectionEntry({
            id: correctionCount,
            warning: warning,
            correction: correction,
            reference: reference,
            timestamp: block.timestamp
        });
        emit CorrectionLogged(correctionCount, warning, correction);
    }

    function viewCorrection(uint256 id) external view returns (CorrectionEntry memory) {
        return corrections[id];
    }
}
