pragma solidity ^0.8.20;

contract AffordabilityProtocol {
    address public admin;

    struct CostArc {
        string category;     // e.g. EV, hybrid
        string factor;       // e.g. battery cost, subsidies
        string impact;       // e.g. consumer adoption, barrier
        uint256 timestamp;
    }

    CostArc[] public costs;

    event CostLogged(string category, string factor, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCost(string calldata category, string calldata factor, string calldata impact) external onlyAdmin {
        costs.push(CostArc(category, factor, impact, block.timestamp));
        emit CostLogged(category, factor, impact, block.timestamp);
    }

    function totalCosts() external view returns (uint256) {
        return costs.length;
    }
}
