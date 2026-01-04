pragma solidity ^0.8.20;

contract IdeologyAuditProtocol {
    address public admin;
    struct Ideology { string name; string stance; uint256 timestamp; }
    Ideology[] public ideologies;
    event IdeologyLogged(string name, string stance, uint256 timestamp);
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }
    function logIdeology(string calldata name, string calldata stance) external onlyAdmin {
        ideologies.push(Ideology(name, stance, block.timestamp));
        emit IdeologyLogged(name, stance, block.timestamp);
    }
}
