pragma solidity ^0.8.20;

contract StrategicPartnershipTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct PartnershipRule {
        uint256 id;
        string principle;   // Strategic Partnership
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PartnershipRule) public treaties;
    event PartnershipRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePartnershipRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = PartnershipRule(treatyCount, principle, description, block.timestamp);
        emit PartnershipRuleDeclared(treatyCount, principle, description);
    }
}
