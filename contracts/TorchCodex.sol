pragma solidity ^0.8.20;

contract TorchCodex {
    address public overseer;
    uint256 public codexCount;

    struct TorchRule {
        uint256 id;
        string principle;   // Torch, Right View, Forerunner
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TorchRule) public rules;
    event TorchRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTorchRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = TorchRule(codexCount, principle, description, block.timestamp);
        emit TorchRuleDeclared(codexCount, principle, description);
    }
}
