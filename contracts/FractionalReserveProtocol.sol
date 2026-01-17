pragma solidity ^0.8.20;

contract FractionalReserveProtocol {
    address public admin;

    struct ReserveSystem {
        string typeOfSystem; // e.g. fractional reserve, 100% treasury-backed
        string riskLevel;    // e.g. high, low
        uint256 timestamp;
    }

    ReserveSystem[] public systems;

    event ReserveSystemLogged(string typeOfSystem, string riskLevel, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSystem(string calldata typeOfSystem, string calldata riskLevel) external onlyAdmin {
        systems.push(ReserveSystem(typeOfSystem, riskLevel, block.timestamp));
        emit ReserveSystemLogged(typeOfSystem, riskLevel, block.timestamp);
    }

    function totalSystems() external view returns (uint256) {
        return systems.length;
    }
}
