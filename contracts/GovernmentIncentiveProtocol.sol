pragma solidity ^0.8.20;

contract GovernmentIncentiveProtocol {
    address public admin;

    struct Incentive {
        string authority;    // e.g. DOLE, wage board
        string measure;      // e.g. tax break, subsidy
        string effect;       // e.g. encourage wage standardization
        uint256 timestamp;
    }

    Incentive[] public incentives;

    event IncentiveLogged(string authority, string measure, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIncentive(string calldata authority, string calldata measure, string calldata effect) external onlyAdmin {
        incentives.push(Incentive(authority, measure, effect, block.timestamp));
        emit IncentiveLogged(authority, measure, effect, block.timestamp);
    }

    function totalIncentives() external view returns (uint256) {
        return incentives.length;
    }
}
