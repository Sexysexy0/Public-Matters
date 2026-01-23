pragma solidity ^0.8.20;

contract SurveillanceProtocol {
    address public admin;

    struct Surveillance {
        string method;       // e.g. phone tracking, device hacking
        string target;       // e.g. public figure, national security officer
        string effect;       // e.g. access to data, monitoring influence
        uint256 timestamp;
    }

    Surveillance[] public surveillances;

    event SurveillanceLogged(string method, string target, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSurveillance(string calldata method, string calldata target, string calldata effect) external onlyAdmin {
        surveillances.push(Surveillance(method, target, effect, block.timestamp));
        emit SurveillanceLogged(method, target, effect, block.timestamp);
    }

    function totalSurveillances() external view returns (uint256) {
        return surveillances.length;
    }
}
