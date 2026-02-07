// FundingFlowProtocol.sol
pragma solidity ^0.8.0;

contract FundingFlowProtocol {
    struct Flow {
        uint256 id;
        string source;   // e.g. "Donor", "Network"
        int256 amount;   // positive = inflow, negative = outflow
        uint256 timestamp;
    }

    uint256 public flowCount;
    mapping(uint256 => Flow) public flows;

    event FlowLogged(uint256 id, string source, int256 amount, uint256 timestamp);
    event FundingDeclared(string message);

    function logFlow(string memory source, int256 amount) public {
        flowCount++;
        flows[flowCount] = Flow(flowCount, source, amount, block.timestamp);
        emit FlowLogged(flowCount, source, amount, block.timestamp);
    }

    function declareFunding() public {
        emit FundingDeclared("Funding Flow Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}
