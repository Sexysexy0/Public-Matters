pragma solidity ^0.8.20;

contract OrderCodex {
    address public overseer;
    uint256 public codexCount;

    struct OrderRule {
        uint256 id;
        string principle;   // Order, Stability, Peace
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OrderRule) public rules;
    event OrderRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOrderRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = OrderRule(codexCount, principle, description, block.timestamp);
        emit OrderRuleDeclared(codexCount, principle, description);
    }
}
