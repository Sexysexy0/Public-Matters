pragma solidity ^0.8.20;

contract LiberationProtocol {
    address public admin;

    struct Action {
        string cause;        // e.g. protest, freedom, communal dignity
        string status;       // e.g. initiated, ongoing, achieved
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string cause, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAction(string calldata cause, string calldata status) external onlyAdmin {
        actions.push(Action(cause, status, block.timestamp));
        emit ActionLogged(cause, status, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
