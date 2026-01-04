pragma solidity ^0.8.20;

contract ThreatActorProfileProtocol {
    address public admin;

    struct Actor {
        string name;         // e.g. APT group, hacker alias
        string tactic;       // e.g. phishing, ransomware, supply chain
        uint256 timestamp;
    }

    Actor[] public actors;

    event ActorLogged(string name, string tactic, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logActor(string calldata name, string calldata tactic) external onlyAdmin {
        actors.push(Actor(name, tactic, block.timestamp));
        emit ActorLogged(name, tactic, block.timestamp);
    }

    function totalActors() external view returns (uint256) {
        return actors.length;
    }
}
