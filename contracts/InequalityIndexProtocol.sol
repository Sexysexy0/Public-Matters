pragma solidity ^0.8.20;

contract InequalityIndexProtocol {
    address public admin;

    struct Inequality {
        string metric;       // e.g. Gini coefficient, Wealth gap
        string observation;  // e.g. Rising, Declining
        uint256 timestamp;
    }

    Inequality[] public inequalities;

    event InequalityLogged(string metric, string observation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInequality(string calldata metric, string calldata observation) external onlyAdmin {
        inequalities.push(Inequality(metric, observation, block.timestamp));
        emit InequalityLogged(metric, observation, block.timestamp);
    }

    function totalInequalities() external view returns (uint256) {
        return inequalities.length;
    }
}
