pragma solidity ^0.8.20;

contract ConsensusProtocol {
    address public admin;

    struct Decision {
        string proposal;     // e.g. project, reform, communal action
        uint256 approvals;
        uint256 rejections;
        uint256 timestamp;
    }

    Decision[] public decisions;

    event DecisionLogged(string proposal, uint256 approvals, uint256 rejections, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDecision(string calldata proposal, uint256 approvals, uint256 rejections) external onlyAdmin {
        decisions.push(Decision(proposal, approvals, rejections, block.timestamp));
        emit DecisionLogged(proposal, approvals, rejections, block.timestamp);
    }

    function totalDecisions() external view returns (uint256) {
        return decisions.length;
    }
}
