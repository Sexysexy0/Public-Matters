// SPDX-License-Identifier: MIT
// Contract Name: EthicalGovernanceCodex
// Purpose: Standardize ethical behaviour across all governance layers
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract EthicalGovernanceCodex {
    address public chiefOperator;
    uint256 public codexCount;

    struct Codex {
        string principle;
        string ethicalStandard;
        uint256 timestamp;
    }

    Codex[] public codices;

    event CodexAdded(string principle, string ethicalStandard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        codexCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new ethical governance clause
    function addCodex(string memory principle, string memory ethicalStandard) public onlyChief {
        codices.push(Codex(principle, ethicalStandard, block.timestamp));
        codexCount++;
        emit CodexAdded(principle, ethicalStandard, block.timestamp);
    }

    // View codex details
    function getCodex(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < codices.length, "Invalid codex index");
        Codex memory c = codices[index];
        return (c.principle, c.ethicalStandard, c.timestamp);
    }
}
