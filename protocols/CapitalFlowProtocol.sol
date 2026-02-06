// CapitalFlowProtocol.sol
pragma solidity ^0.8.0;

contract CapitalFlowProtocol {
    struct Flow {
        uint256 id;
        string source;   // e.g. "Institutional ETF", "Retail Exchange"
        int256 netFlow;  // positive = inflow, negative = outflow
        uint256 timestamp;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowLogged(uint256 id, string source, int256 netFlow, uint256 timestamp);
    event CapitalDeclared(string message);

    function logFlow(string memory source, int256 netFlow) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, source, netFlow, block.timestamp);
        emit FlowLogged(flowCount, source, netFlow, block.timestamp);
    }

    function declareCapital() public {
        emit CapitalDeclared("Capital Flow Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
