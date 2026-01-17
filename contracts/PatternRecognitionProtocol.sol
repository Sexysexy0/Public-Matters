pragma solidity ^0.8.20;

contract PatternRecognitionProtocol {
    address public admin;

    struct Pattern {
        string cycle;        // e.g. historical cycle, market trend
        string insight;      // e.g. reduces fear, gives control
        uint256 timestamp;
    }

    Pattern[] public patterns;

    event PatternLogged(string cycle, string insight, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPattern(string calldata cycle, string calldata insight) external onlyAdmin {
        patterns.push(Pattern(cycle, insight, block.timestamp));
        emit PatternLogged(cycle, insight, block.timestamp);
    }

    function totalPatterns() external view returns (uint256) {
        return patterns.length;
    }
}
