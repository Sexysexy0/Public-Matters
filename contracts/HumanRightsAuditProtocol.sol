pragma solidity ^0.8.20;

contract HumanRightsAuditProtocol {
    address public admin;

    struct Abuse {
        string location;     // e.g. prison, detention camp
        string violation;    // e.g. torture, starvation, mistreatment
        uint256 timestamp;
    }

    Abuse[] public abuses;

    event AbuseLogged(string location, string violation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAbuse(string calldata location, string calldata violation) external onlyAdmin {
        abuses.push(Abuse(location, violation, block.timestamp));
        emit AbuseLogged(location, violation, block.timestamp);
    }

    function totalAbuses() external view returns (uint256) {
        return abuses.length;
    }
}
