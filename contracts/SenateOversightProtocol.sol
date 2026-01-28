pragma solidity ^0.8.20;

contract SenateOversightProtocol {
    address public admin;

    struct Oversight {
        string committee;    // e.g. Environment, Natural Resources, Climate Change
        string action;       // e.g. convene hearings, summon agencies
        string expectation;  // e.g. accountability, representation
        uint256 timestamp;
    }

    Oversight[] public oversights;

    event OversightLogged(string committee, string action, string expectation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logOversight(string calldata committee, string calldata action, string calldata expectation) external onlyAdmin {
        oversights.push(Oversight(committee, action, expectation, block.timestamp));
        emit OversightLogged(committee, action, expectation, block.timestamp);
    }

    function totalOversights() external view returns (uint256) {
        return oversights.length;
    }
}
