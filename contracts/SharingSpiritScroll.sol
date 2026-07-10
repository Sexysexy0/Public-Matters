pragma solidity ^0.8.20;

contract SharingSpiritScroll {
    address public overseer;
    uint256 public scrollCount;

    struct SharingRule {
        uint256 id;
        string principle;   // Sharing Spirit, Generosity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SharingRule) public rules;
    event SharingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSharingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = SharingRule(scrollCount, principle, description, block.timestamp);
        emit SharingRuleDeclared(scrollCount, principle, description);
    }
}
