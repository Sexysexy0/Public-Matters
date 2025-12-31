// contracts/BalancedCoverage.sol
pragma solidity ^0.8.20;

/**
 * @title BalancedCoverage
 * @notice Logs efforts to ensure balanced and reliable media coverage.
 */
contract BalancedCoverage {
    address public admin;

    struct Coverage {
        string topic;       // "Politics", "Economy", "Security"
        string description;
        uint256 timestamp;
    }

    Coverage[] public coverages;

    event CoverageLogged(string topic, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logCoverage(string calldata topic, string calldata description) external onlyAdmin {
        coverages.push(Coverage(topic, description, block.timestamp));
        emit CoverageLogged(topic, description, block.timestamp);
    }
}
