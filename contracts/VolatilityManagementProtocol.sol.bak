// VolatilityManagementProtocol.sol
pragma solidity ^0.8.0;

contract VolatilityManagementProtocol {
    struct Strategy {
        uint256 id;
        string approach;   // e.g. "Diversify portfolio"
        string outcome;    // e.g. "Reduced risk exposure"
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
