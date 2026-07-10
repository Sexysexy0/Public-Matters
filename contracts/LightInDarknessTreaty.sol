pragma solidity ^0.8.20;

contract LightInDarknessTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct LightRule {
        uint256 id;
        string principle;   // Light in Darkness, Beacon
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LightRule) public treaties;
    event LightRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLightRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = LightRule(treatyCount, principle, description, block.timestamp);
        emit LightRuleDeclared(treatyCount, principle, description);
    }
}
