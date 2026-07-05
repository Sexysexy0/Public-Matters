pragma solidity ^0.8.20;

contract SpiralWideningTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct SpiralRule {
        uint256 id;
        string principle;   // Spiral Widening, Growth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SpiralRule) public treaties;
    event SpiralRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSpiralRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = SpiralRule(treatyCount, principle, description, block.timestamp);
        emit SpiralRuleDeclared(treatyCount, principle, description);
    }
}
