// ETFSignalProtocol.sol
pragma solidity ^0.8.0;

contract ETFSignalProtocol {
    struct Flow {
        uint256 id;
        string fund;   // e.g. "BTC ETF", "ETH ETF"
        int256 netFlow; // positive = inflow, negative = outflow
        uint256 timestamp;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowLogged(uint256 id, string fund, int256 netFlow, uint256 timestamp);
    event ETFDeclared(string message);

    function logFlow(string memory fund, int256 netFlow) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, fund, netFlow, block.timestamp);
        emit FlowLogged(flowCount, fund, netFlow, block.timestamp);
    }

    function declareETF() public {
        emit ETFDeclared("ETF Signal Protocol: validator-grade audits encoded into communal trust.");
    }
}
