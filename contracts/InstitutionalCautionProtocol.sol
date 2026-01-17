pragma solidity ^0.8.20;

contract InstitutionalCautionProtocol {
    address public admin;

    struct Decision {
        string asset;        // e.g. Bitcoin, gold
        string rationale;    // e.g. fiduciary duty, avoid zeros
        uint256 timestamp;
    }

    Decision[] public decisions;

    event DecisionLogged(string asset, string rationale, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDecision(string calldata asset, string calldata rationale) external onlyAdmin {
        decisions.push(Decision(asset, rationale, block.timestamp));
        emit DecisionLogged(asset, rationale, block.timestamp);
    }

    function totalDecisions() external view returns (uint256) {
        return decisions.length;
    }
}
