pragma solidity ^0.8.20;

contract TalentEscapeProtocol {
    address public admin;

    struct Talent {
        string profession;   // e.g. doctors, teachers, engineers
        string method;       // e.g. overseas work, asylum, migration
        string risk;         // e.g. brain drain, exposure of secrets
        uint256 timestamp;
    }

    Talent[] public talents;

    event TalentLogged(string profession, string method, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTalent(string calldata profession, string calldata method, string calldata risk) external onlyAdmin {
        talents.push(Talent(profession, method, risk, block.timestamp));
        emit TalentLogged(profession, method, risk, block.timestamp);
    }

    function totalTalents() external view returns (uint256) {
        return talents.length;
    }
}
