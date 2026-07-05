pragma solidity ^0.8.20;

contract CareTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct CareRule {
        uint256 id;
        string principle;   // Care, Nurturing, Support
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CareRule) public treaties;
    event CareRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCareRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = CareRule(treatyCount, principle, description, block.timestamp);
        emit CareRuleDeclared(treatyCount, principle, description);
    }
}
