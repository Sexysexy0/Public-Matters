pragma solidity ^0.8.20;

contract CivilSocietyProtocol {
    address public admin;

    struct Action {
        string group;        // e.g. residents, NGOs
        string protest;      // e.g. human barricade, open letter
        string response;     // e.g. arrests, hearings call
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string group, string protest, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAction(string calldata group, string calldata protest, string calldata response) external onlyAdmin {
        actions.push(Action(group, protest, response, block.timestamp));
        emit ActionLogged(group, protest, response, block.timestamp);
    }

    function totalActions() external view returns (uint256) {
        return actions.length;
    }
}
