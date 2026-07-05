pragma solidity ^0.8.20;

contract SamsaraSurpassingLedger {
    address public overseer;
    uint256 public entryCount;

    struct SamsaraRule {
        uint256 id;
        string principle;   // Surpassing Samsāra, Exit
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SamsaraRule) public entries;
    event SamsaraRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSamsaraRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = SamsaraRule(entryCount, principle, description, block.timestamp);
        emit SamsaraRuleDeclared(entryCount, principle, description);
    }
}
