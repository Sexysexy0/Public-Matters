pragma solidity ^0.8.20;

contract InquiryScroll {
    address public overseer;
    uint256 public scrollCount;

    struct InquiryRule {
        uint256 id;
        string principle;   // Questioning, Investigation, Knowledge
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InquiryRule) public rules;
    event InquiryRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareInquiryRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = InquiryRule(scrollCount, principle, description, block.timestamp);
        emit InquiryRuleDeclared(scrollCount, principle, description);
    }
}
