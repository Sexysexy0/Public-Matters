pragma solidity ^0.8.20;

contract ChargingInfrastructureProtocol {
    address public admin;

    struct Infrastructure {
        string region;       // e.g. EU, UK
        string status;       // e.g. expanding, insufficient
        string effect;       // e.g. consumer confidence, adoption barrier
        uint256 timestamp;
    }

    Infrastructure[] public infrastructures;

    event InfrastructureLogged(string region, string status, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logInfrastructure(string calldata region, string calldata status, string calldata effect) external onlyAdmin {
        infrastructures.push(Infrastructure(region, status, effect, block.timestamp));
        emit InfrastructureLogged(region, status, effect, block.timestamp);
    }

    function totalInfrastructures() external view returns (uint256) {
        return infrastructures.length;
    }
}
