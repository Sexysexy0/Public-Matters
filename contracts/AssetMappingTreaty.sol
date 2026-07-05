pragma solidity ^0.8.20;

contract AssetMappingTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct AssetRule {
        uint256 id;
        string principle;   // Asset Mapping, IP Tracking
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AssetRule) public treaties;
    event AssetRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAssetRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = AssetRule(treatyCount, principle, description, block.timestamp);
        emit AssetRuleDeclared(treatyCount, principle, description);
    }
}
