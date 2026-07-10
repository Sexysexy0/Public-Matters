pragma solidity ^0.8.20;

contract HonestyCodex {
    address public overseer;
    uint256 public codexCount;

    struct HonestyRule {
        uint256 id;
        string principle;   // Truthful Communication, Fairness, Transparency
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HonestyRule) public rules;
    event HonestyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHonestyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = HonestyRule(codexCount, principle, description, block.timestamp);
        emit HonestyRuleDeclared(codexCount, principle, description);
    }
}
