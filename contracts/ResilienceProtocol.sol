// ResilienceProtocol.sol
pragma solidity ^0.8.0;

contract ResilienceProtocol {
    struct Strategy {
        uint256 id;
        string challenge;  // e.g. "Inflation Shock"
        string safeguard;  // e.g. "Prepare for crises with adaptive measures"
        uint256 timestamp;
    }

    uint256 public strategyCount;
    mapping(uint256 => Strategy) public strategies;

    event StrategyLogged(uint256 id, string challenge, string safeguard);

    function logStrategy(string memory challenge, string memory safeguard) public {
        strategyCount++;
        strategies[strategyCount] = Strategy(strategyCount, challenge, safeguard, block.timestamp);
        emit StrategyLogged(strategyCount, challenge, safeguard);
    }
}
