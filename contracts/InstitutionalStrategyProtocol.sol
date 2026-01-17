pragma solidity ^0.8.20;

contract InstitutionalStrategyProtocol {
    address public admin;

    struct Strategy {
        string move;         // e.g. remove Bitcoin, reallocate to gold
        string rationale;    // e.g. fiduciary duty, risk avoidance
        uint256 timestamp;
    }

    Strategy[] public strategies;

    event StrategyLogged(string move, string rationale, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStrategy(string calldata move, string calldata rationale) external onlyAdmin {
        strategies.push(Strategy(move, rationale, block.timestamp));
        emit StrategyLogged(move, rationale, block.timestamp);
    }

    function totalStrategies() external view returns (uint256) {
        return strategies.length;
    }
}
