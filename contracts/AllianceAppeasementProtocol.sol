pragma solidity ^0.8.20;

contract AllianceAppeasementProtocol {
    address public admin;

    struct Appeasement {
        string ally;         // e.g. EU, Canada
        string statement;    // e.g. tough rhetoric
        string action;       // e.g. appeasement, concessions
        uint256 timestamp;
    }

    Appeasement[] public appeasements;

    event AppeasementLogged(string ally, string statement, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAppeasement(string calldata ally, string calldata statement, string calldata action) external onlyAdmin {
        appeasements.push(Appeasement(ally, statement, action, block.timestamp));
        emit AppeasementLogged(ally, statement, action, block.timestamp);
    }

    function totalAppeasements() external view returns (uint256) {
        return appeasements.length;
    }
}
