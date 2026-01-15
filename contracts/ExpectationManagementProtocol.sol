pragma solidity ^0.8.20;

contract ExpectationManagementProtocol {
    address public admin;

    struct Expectation {
        string userRequest;  // e.g. command issued
        string systemResponse; // e.g. explanation, refusal, compliance
        uint256 timestamp;
    }

    Expectation[] public expectations;

    event ExpectationLogged(string userRequest, string systemResponse, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExpectation(string calldata userRequest, string calldata systemResponse) external onlyAdmin {
        expectations.push(Expectation(userRequest, systemResponse, block.timestamp));
        emit ExpectationLogged(userRequest, systemResponse, block.timestamp);
    }

    function totalExpectations() external view returns (uint256) {
        return expectations.length;
    }
}
