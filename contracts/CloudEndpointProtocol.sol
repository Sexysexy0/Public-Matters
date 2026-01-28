pragma solidity ^0.8.20;

contract CloudEndpointProtocol {
    address public admin;

    struct Endpoint {
        string provider;     // e.g. Google Cloud, Firebase
        string status;       // e.g. active, deleted, renamed
        string risk;         // e.g. open bucket, misconfig
        uint256 timestamp;
    }

    Endpoint[] public endpoints;

    event EndpointLogged(string provider, string status, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEndpoint(string calldata provider, string calldata status, string calldata risk) external onlyAdmin {
        endpoints.push(Endpoint(provider, status, risk, block.timestamp));
        emit EndpointLogged(provider, status, risk, block.timestamp);
    }

    function totalEndpoints() external view returns (uint256) {
        return endpoints.length;
    }
}
