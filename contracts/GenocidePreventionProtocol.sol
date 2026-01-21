pragma solidity ^0.8.20;

contract GenocidePreventionProtocol {
    address public admin;

    struct Action {
        string measure;      // e.g. sanctions, ICC case, awareness campaign
        string goal;         // e.g. stop genocide, protect communities
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string measure, string goal, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAction(string calldata measure, string calldata goal) external onlyAdmin {
        actions.push(Action(measure, goal, block.timestamp));
        emit ActionLogged(measure, goal, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
