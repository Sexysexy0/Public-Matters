pragma solidity ^0.8.20;

contract HopeCodex {
    address public overseer;
    uint256 public codexCount;

    struct HopeRule {
        uint256 id;
        string principle;   // Hope, Light, Renewal
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HopeRule) public rules;
    event HopeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHopeRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = HopeRule(codexCount, principle, description, block.timestamp);
        emit HopeRuleDeclared(codexCount, principle, description);
    }
}
