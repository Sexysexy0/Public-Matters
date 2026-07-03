// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthConditionsCodex
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of truth condition safeguards
contract TruthConditionsCodex {
    address public overseer;
    uint256 public truthCount;

    struct TruthRule {
        uint256 id;
        string principle; // Compositional Truth, Referential Truth, Pragmatic Truth, Contextual Truth
        string expression; // encoded truth condition form
        uint256 timestamp;
    }

    mapping(uint256 => TruthRule) public truthRules;

    event TruthLogged(uint256 indexed id, string principle, string expression);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTruth(
        string calldata principle,
        string calldata expression
    ) external onlyOverseer {
        truthCount++;
        truthRules[truthCount] = TruthRule({
            id: truthCount,
            principle: principle,
            expression: expression,
            timestamp: block.timestamp
        });
        emit TruthLogged(truthCount, principle, expression);
    }

    function viewTruth(uint256 id) external view returns (TruthRule memory) {
        return truthRules[id];
    }
}
