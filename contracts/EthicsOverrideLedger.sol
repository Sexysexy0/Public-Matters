pragma solidity ^0.8.20;

/// @title EthicsOverrideLedger
/// @notice Encodes ethical override rights in AI systems.
/// @dev Anchors human ethics safeguards, override rights, and accountability.

contract EthicsOverrideLedger {
    address public overseer;
    uint256 public entryCount;

    struct EthicsRule {
        uint256 id;
        string principle;   // Ethics, Override, Accountability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EthicsRule> public entries;
    event EthicsRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEthicsRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EthicsRule(entryCount, principle, description, block.timestamp);
        emit EthicsRuleDeclared(entryCount, principle, description);
    }
}
