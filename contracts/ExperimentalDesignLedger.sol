pragma solidity ^0.8.20;

contract ExperimentalDesignLedger {
    address public overseer;
    uint256 public entryCount;

    struct DesignRule {
        uint256 id;
        string principle;   // Experimental Design, Iterative Creativity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DesignRule) public entries;
    event DesignRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDesignRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = DesignRule(entryCount, principle, description, block.timestamp);
        emit DesignRuleDeclared(entryCount, principle, description);
    }
}
