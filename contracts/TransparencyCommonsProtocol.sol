pragma solidity ^0.8.20;

contract TransparencyCommonsProtocol {
    address public admin;

    struct Action {
        string official;
        string description;
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string official, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAction(string calldata official, string calldata description) external onlyAdmin {
        actions.push(Action(official, description, block.timestamp));
        emit ActionLogged(official, description, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
