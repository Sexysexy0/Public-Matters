pragma solidity ^0.8.20;

contract PolicyIncentiveProtocol {
    address public admin;

    struct Incentive {
        string region;       // e.g. EU
        string policy;       // e.g. subsidies, tax breaks
        string impact;       // e.g. boosted EV adoption, hybrid preference
        uint256 timestamp;
    }

    Incentive[] public incentives;

    event IncentiveLogged(string region, string policy, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIncentive(string calldata region, string calldata policy, string calldata impact) external onlyAdmin {
        incentives.push(Incentive(region, policy, impact, block.timestamp));
        emit IncentiveLogged(region, policy, impact, block.timestamp);
    }

    function totalIncentives() external view returns (uint256) {
        return incentives.length;
    }
}
