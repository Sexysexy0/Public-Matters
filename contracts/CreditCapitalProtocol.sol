pragma solidity ^0.8.20;

contract CreditCapitalProtocol {
    address public admin;

    struct Flow {
        string client;       // e.g. consumer, institution
        uint256 amount;      // credit or capital extended
        uint256 timestamp;
    }

    Flow[] public flows;

    event FlowLogged(string client, uint256 amount, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFlow(string calldata client, uint256 amount) external onlyAdmin {
        flows.push(Flow(client, amount, block.timestamp));
        emit FlowLogged(client, amount, block.timestamp);
    }

    function totalFlows() external view returns (uint256) {
        return flows.length;
    }
}
