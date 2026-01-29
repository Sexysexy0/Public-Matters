pragma solidity ^0.8.20;

contract GlobalCooperationProtocol {
    address public admin;

    struct Cooperation {
        string participants; // e.g. Institutions, Communities
        string purpose;      // e.g. Hold BTC, Build equity
        string vibe;         // e.g. Collective storm
        uint256 timestamp;
    }

    Cooperation[] public cooperations;

    event CooperationLogged(string participants, string purpose, string vibe, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCooperation(string calldata participants, string calldata purpose, string calldata vibe) external onlyAdmin {
        cooperations.push(Cooperation(participants, purpose, vibe, block.timestamp));
        emit CooperationLogged(participants, purpose, vibe, block.timestamp);
    }

    function totalCooperations() external view returns (uint256) {
        return cooperations.length;
    }
}
