pragma solidity ^0.8.20;

contract GuidanceTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct GuidanceRule {
        uint256 id;
        string principle;   // Guidance, Moral Direction
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GuidanceRule) public treaties;
    event GuidanceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGuidanceRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = GuidanceRule(treatyCount, principle, description, block.timestamp);
        emit GuidanceRuleDeclared(treatyCount, principle, description);
    }
}
