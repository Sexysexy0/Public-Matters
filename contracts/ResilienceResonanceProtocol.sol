// ResilienceResonanceProtocol.sol
pragma solidity ^0.8.0;

contract ResilienceResonanceProtocol {
    struct Strategy {
        uint256 id;
        string domain;    // e.g. "Database Failover"
        string measure;   // e.g. "Automatic replication"
        string outcome;   // e.g. "Stable"
        uint256 timestamp;
    }

    uint256 public strategyCount;
    mapping(uint256 => Strategy) public strategies;

    event StrategyLogged(uint256 id, string domain, string measure, string outcome);

    function logStrategy(string memory domain, string memory measure, string memory outcome) public {
        strategyCount++;
        strategies[strategyCount] = Strategy(strategyCount, domain, measure, outcome, block.timestamp);
        emit StrategyLogged(strategyCount, domain, measure, outcome);
    }
}
