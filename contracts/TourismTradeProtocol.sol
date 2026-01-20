pragma solidity ^0.8.20;

contract TourismTradeProtocol {
    address public admin;

    struct Flow {
        string sector;       // e.g. tourism, trade, investment
        string impact;       // e.g. regional development, GDP growth, job creation
        uint256 timestamp;
    }

    Flow[] public flows;

    event FlowLogged(string sector, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFlow(string calldata sector, string calldata impact) external onlyAdmin {
        flows.push(Flow(sector, impact, block.timestamp));
        emit FlowLogged(sector, impact, block.timestamp);
    }

    function totalFlows() external view returns (uint256) {
        return flows.length;
    }
}
