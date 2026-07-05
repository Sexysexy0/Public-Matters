pragma solidity ^0.8.20;

contract BraveryTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct BraveryRule {
        uint256 id;
        string principle;   // Fearless Action, Moral Strength
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BraveryRule) public treaties;
    event BraveryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBraveryRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = BraveryRule(treatyCount, principle, description, block.timestamp);
        emit BraveryRuleDeclared(treatyCount, principle, description);
    }
}
