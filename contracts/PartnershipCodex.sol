pragma solidity ^0.8.20;

contract PartnershipCodex {
    address public overseer;
    uint256 public codexCount;

    struct PartnershipRule {
        uint256 id;
        string principle;   // Partnership, Joint Ventures, Cooperation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PartnershipRule) public rules;
    event PartnershipRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePartnershipRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = PartnershipRule(codexCount, principle, description, block.timestamp);
        emit PartnershipRuleDeclared(codexCount, principle, description);
    }
}
