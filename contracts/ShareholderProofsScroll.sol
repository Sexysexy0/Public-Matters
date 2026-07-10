pragma solidity ^0.8.20;

contract ShareholderProofsScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ProofRule {
        uint256 id;
        string principle;   // Shareholder Proofs, Governance Communications
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ProofRule) public rules;
    event ProofRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareProofRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ProofRule(scrollCount, principle, description, block.timestamp);
        emit ProofRuleDeclared(scrollCount, principle, description);
    }
}
