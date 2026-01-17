pragma solidity ^0.8.20;

contract SuccessPatternProtocol {
    address public admin;

    struct Pattern {
        string entity;       // e.g. person, business
        string trait;        // e.g. resilience, adaptability, service
        uint256 timestamp;
    }

    Pattern[] public patterns;

    event PatternLogged(string entity, string trait, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPattern(string calldata entity, string calldata trait) external onlyAdmin {
        patterns.push(Pattern(entity, trait, block.timestamp));
        emit PatternLogged(entity, trait, block.timestamp);
    }

    function totalPatterns() external view returns (uint256) {
        return patterns.length;
    }
}
