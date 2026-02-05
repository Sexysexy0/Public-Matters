// InstitutionalFlowMonitor.sol
pragma solidity ^0.8.0;

contract InstitutionalFlowMonitor {
    struct Flow {
        uint256 id;
        string entity;   // e.g. "ETF", "Exchange"
        int256 netFlow;  // positive = inflow, negative = outflow
        uint256 timestamp;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowLogged(uint256 id, string entity, int256 netFlow, uint256 timestamp);
    event InstitutionDeclared(string message);

    function logFlow(string memory entity, int256 netFlow) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, entity, netFlow, block.timestamp);
        emit FlowLogged(flowCount, entity, netFlow, block.timestamp);
    }

    function declareInstitution() public {
        emit InstitutionDeclared("Institutional Flow Monitor: validator-grade audits encoded into communal trust.");
    }
}
