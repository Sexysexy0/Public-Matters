// contracts/PolicyResponse.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PolicyResponse
 * @notice Logs government and business responses to economic slowdown.
 */
contract PolicyResponse {
    address public admin;

    struct Response {
        string actor;      // "Government", "Business"
        string measure;    // "Reform", "Diversification"
        string status;     // "Proposed", "Implemented"
        uint256 timestamp;
    }

    Response[] public responses;

    event ResponseLogged(string actor, string measure, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logResponse(string calldata actor, string calldata measure, string calldata status) external onlyAdmin {
        responses.push(Response(actor, measure, status, block.timestamp));
        emit ResponseLogged(actor, measure, status, block.timestamp);
    }

    function totalResponses() external view returns (uint256) { return responses.length; }

    function getResponse(uint256 id) external view returns (Response memory) {
        require(id < responses.length, "Invalid id");
        return responses[id];
    }
}
