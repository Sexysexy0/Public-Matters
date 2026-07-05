pragma solidity ^0.8.20;

contract InquiryTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct InquiryRule {
        uint256 id;
        string principle;   // Questioning, Investigation, Truth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InquiryRule) public treaties;
    event InquiryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareInquiryRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = InquiryRule(treatyCount, principle, description, block.timestamp);
        emit InquiryRuleDeclared(treatyCount, principle, description);
    }
}
