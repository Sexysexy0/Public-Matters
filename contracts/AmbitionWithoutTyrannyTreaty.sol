pragma solidity ^0.8.20;

contract AmbitionWithoutTyrannyTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct AmbitionRule {
        uint256 id;
        string principle;   // Ambition Without Tyranny
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AmbitionRule) public treaties;
    event AmbitionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAmbitionRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = AmbitionRule(treatyCount, principle, description, block.timestamp);
        emit AmbitionRuleDeclared(treatyCount, principle, description);
    }
}
