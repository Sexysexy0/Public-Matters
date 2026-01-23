pragma solidity ^0.8.20;

contract UnionNegotiationProtocol {
    address public admin;

    struct Negotiation {
        string unionName;    // e.g. labor federation
        string demand;       // e.g. equal pay clause
        string outcome;      // e.g. standardized wage agreement
        uint256 timestamp;
    }

    Negotiation[] public negotiations;

    event NegotiationLogged(string unionName, string demand, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logNegotiation(string calldata unionName, string calldata demand, string calldata outcome) external onlyAdmin {
        negotiations.push(Negotiation(unionName, demand, outcome, block.timestamp));
        emit NegotiationLogged(unionName, demand, outcome, block.timestamp);
    }

    function totalNegotiations() external view returns (uint256) {
        return negotiations.length;
    }
}
