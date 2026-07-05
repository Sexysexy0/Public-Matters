pragma solidity ^0.8.20;

contract LiteracyTorchScroll {
    address public overseer;
    uint256 public scrollCount;

    struct TorchSightRule {
        uint256 id;
        string principle;   // Literacy Torch, Belief to Sight
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TorchSightRule) public rules;
    event TorchSightRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTorchSightRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = TorchSightRule(scrollCount, principle, description, block.timestamp);
        emit TorchSightRuleDeclared(scrollCount, principle, description);
    }
}
