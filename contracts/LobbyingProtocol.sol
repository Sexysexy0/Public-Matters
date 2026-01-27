pragma solidity ^0.8.20;

contract LobbyingProtocol {
    address public admin;

    struct Lobby {
        string actor;        // e.g. OpenAI, Technet
        string tactic;       // e.g. subpoenas, shadow groups
        string target;       // e.g. California Assembly, regulators
        uint256 timestamp;
    }

    Lobby[] public lobbies;

    event LobbyLogged(string actor, string tactic, string target, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLobby(string calldata actor, string calldata tactic, string calldata target) external onlyAdmin {
        lobbies.push(Lobby(actor, tactic, target, block.timestamp));
        emit LobbyLogged(actor, tactic, target, block.timestamp);
    }

    function totalLobbies() external view returns (uint256) {
        return lobbies.length;
    }
}
