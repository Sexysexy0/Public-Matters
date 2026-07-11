// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSAlphaCovenant
// Purpose: Encodes origin systems, foundational safeguards, and systemic alpha anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSAlphaCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Alpha {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string origin;        // Origin system or foundational safeguard
        string anchor;        // Alpha anchor or protocol
        uint256 timestamp;
    }

    Alpha[] public alphas;

    event AlphaApplied(string domain, string origin, string anchor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyAlpha(string memory domain, string memory origin, string memory anchor) public onlyChief {
        alphas.push(Alpha(domain, origin, anchor, block.timestamp));
        covenantCount++;
        emit AlphaApplied(domain, origin, anchor, block.timestamp);
    }

    function getAlpha(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < alphas.length, "Invalid alpha index");
        Alpha memory a = alphas[index];
        return (a.domain, a.origin, a.anchor, a.timestamp);
    }
}
