// HypeCycleManagementProtocol.sol
pragma solidity ^0.8.0;

contract HypeCycleManagementProtocol {
    struct Strategy {
        uint256 id;
        string approach;   // e.g. "Monitor hype vs. delivery"
        string outcome;    // e.g. "Investor expectations stabilized"
        uint256 timestamp;
    }

    uint256 public strategyCount;
    mapping(uint256 => Strategy) public strategies;

    event StrategyLogged(uint256 id, string approach, string outcome);

    function logStrategy(string memory approach, string memory outcome) public {
        strategyCount++;
        strategies[strategyCount] = Strategy(strategyCount, approach, outcome, block.timestamp);
        emit StrategyLogged(strategyCount, approach, outcome);
    }
}
