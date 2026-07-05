pragma solidity ^0.8.20;

contract HonestyTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct HonestyRule {
        uint256 id;
        string principle;   // Honesty, Truthful Communication
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HonestyRule) public treaties;
    event HonestyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHonestyRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = HonestyRule(treatyCount, principle, description, block.timestamp);
        emit HonestyRuleDeclared(treatyCount, principle, description);
    }
}
