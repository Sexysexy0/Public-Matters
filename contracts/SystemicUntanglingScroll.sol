pragma solidity ^0.8.20;

contract SystemicUntanglingScroll {
    address public overseer;
    uint256 public scrollCount;

    struct UntanglingRule {
        uint256 id;
        string principle;   // Systemic Untangling, Patience Protocols
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UntanglingRule) public rules;
    event UntanglingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUntanglingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = UntanglingRule(scrollCount, principle, description, block.timestamp);
        emit UntanglingRuleDeclared(scrollCount, principle, description);
    }
}
