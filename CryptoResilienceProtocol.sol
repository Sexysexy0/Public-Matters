// CryptoResilienceProtocol.sol
pragma solidity ^0.8.0;

contract CryptoResilienceProtocol {
    // --- Leverage & Liquidation Safeguards ---
    mapping(address => uint256) public leverageRatio;
    mapping(address => bool) public liquidationFlag;

    event LeverageRecorded(address indexed trader, uint256 ratio);
    event LiquidationAlert(address indexed trader, string message);

    function recordLeverage(address trader, uint256 ratio) public {
        leverageRatio[trader] = ratio;
        emit LeverageRecorded(trader, ratio);

        if (ratio > 5) { // example cap
            liquidationFlag[trader] = true;
            emit LiquidationAlert(trader, "Excessive leverage detected. Risk of liquidation.");
        } else {
            liquidationFlag[trader] = false;
        }
    }

    // --- On-chain Activity Monitoring ---
    mapping(address => uint256) public activeAddresses;
    event ActivityRecorded(address indexed network, uint256 activeUsers);
    event ActivityWarning(address indexed network, string message);

    function recordActivity(address network, uint256 activeUsers) public {
        activeAddresses[network] = activeUsers;
        emit ActivityRecorded(network, activeUsers);

        if (activeUsers < 800000) {
            emit ActivityWarning(network, "Low on-chain activity detected. Demand fragile.");
        }
    }

    // --- Breach Alarms ---
    event BreachDetected(string ecosystem, uint256 loss);

    function reportBreach(string memory ecosystem, uint256 loss) public {
        emit BreachDetected(ecosystem, loss);
    }

    // --- ETF Flow Monitoring ---
    mapping(uint256 => int256) public dailyETFFlows;
    event ETFFlowRecorded(uint256 day, int256 flow);
    event ETFFlowAlert(uint256 day, string message);

    function recordETFFlow(uint256 day, int256 flow) public {
        dailyETFFlows[day] = flow;
        emit ETFFlowRecorded(day, flow);

        if (flow < 0) {
            emit ETFFlowAlert(day, "Sustained outflows detected. Institutional de-risking.");
        }
    }
}
