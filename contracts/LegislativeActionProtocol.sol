pragma solidity ^0.8.20;

contract LegislativeActionProtocol {
    address public admin;

    struct Action {
        string body;         // e.g. Congress, wage board
        string proposal;     // e.g. unify wage rates nationwide
        string impact;       // e.g. reduce inequality, enforce equity
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string body, string proposal, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAction(string calldata body, string calldata proposal, string calldata impact) external onlyAdmin {
        actions.push(Action(body, proposal, impact, block.timestamp));
        emit ActionLogged(body, proposal, impact, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
