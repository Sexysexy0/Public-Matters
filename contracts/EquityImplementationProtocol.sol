pragma solidity ^0.8.20;

contract EquityImplementationProtocol {
    address public admin;

    struct Implementation {
        string company;      // e.g. employer adopting equal pay
        string region;       // e.g. NCR, Bulacan
        string action;       // e.g. standardized wage rollout
        uint256 timestamp;
    }

    Implementation[] public implementations;

    event ImplementationLogged(string company, string region, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logImplementation(string calldata company, string calldata region, string calldata action) external onlyAdmin {
        implementations.push(Implementation(company, region, action, block.timestamp));
        emit ImplementationLogged(company, region, action, block.timestamp);
    }

    function totalImplementations() external view returns (uint256) {
        return implementations.length;
    }
}
