pragma solidity ^0.8.20;

contract FederalResponseProtocol {
    address public admin;

    struct Response {
        string operation;    // e.g. Operation Metro Surge
        uint256 agents;      // e.g. 3000
        string purpose;      // e.g. arrest migrants, suppress protests
        uint256 timestamp;
    }

    Response[] public responses;

    event ResponseLogged(string operation, uint256 agents, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logResponse(string calldata operation, uint256 agents, string calldata purpose) external onlyAdmin {
        responses.push(Response(operation, agents, purpose, block.timestamp));
        emit ResponseLogged(operation, agents, purpose, block.timestamp);
    }

    function totalResponses() external view returns (uint256) {
        return responses.length;
    }
}
