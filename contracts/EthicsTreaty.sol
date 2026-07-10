pragma solidity ^0.8.20;

contract EthicsTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct EthicsRule {
        uint256 id;
        string principle;   // Ethics, Right Speech, Right Action, Right Livelihood
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EthicsRule) public treaties;
    event EthicsRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEthicsRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = EthicsRule(treatyCount, principle, description, block.timestamp);
        emit EthicsRuleDeclared(treatyCount, principle, description);
    }
}
