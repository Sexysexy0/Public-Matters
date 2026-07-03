// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ValorCodex
/// @notice Covenant contract to safeguard systemic heroic strength, principled valor, and dignified courage
contract ValorCodex {
    address public overseer;
    uint256 public valorCount;

    struct ValorRule {
        uint256 id;
        string principle; // Heroic Strength, Principled Valor, Noble Sacrifice, Fearless Duty
        string description; // encoded valor safeguard
        uint256 timestamp;
    }

    mapping(uint256 => ValorRule) public valors;

    event ValorLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logValor(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        valorCount++;
        valors[valorCount] = ValorRule({
            id: valorCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit ValorLogged(valorCount, principle, description);
    }

    function viewValor(uint256 id) external view returns (ValorRule memory) {
        return valors[id];
    }
}
