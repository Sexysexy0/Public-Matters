pragma solidity ^0.8.20;

/// @title InnovationSeedFundingCodex
/// @notice Encodes seed funding and faculty reinvention rules.
/// @dev Anchors support for new directions and adaptive reinvention.

contract InnovationSeedFundingCodex {
    address public overseer;
    uint256 public fundingCount;

    struct FundingRule {
        uint256 id;
        string principle;   // Seed, Reinvention, Support
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FundingRule> public rules;
    event FundingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFundingRule(string calldata principle, string calldata description) external onlyOverseer {
        fundingCount++;
        rules[fundingCount] = FundingRule(fundingCount, principle, description, block.timestamp);
        emit FundingRuleDeclared(fundingCount, principle, description);
    }
}
