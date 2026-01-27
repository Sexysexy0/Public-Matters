pragma solidity ^0.8.20;

contract OceanCurrentProtocol {
    address public admin;

    struct Current {
        string origin;       // e.g. Yellow Sea
        string destination;  // e.g. West Philippine Sea
        string cargo;        // e.g. iodine-129 isotopes
        uint256 timestamp;
    }

    Current[] public currents;

    event CurrentLogged(string origin, string destination, string cargo, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCurrent(string calldata origin, string calldata destination, string calldata cargo) external onlyAdmin {
        currents.push(Current(origin, destination, cargo, block.timestamp));
        emit CurrentLogged(origin, destination, cargo, block.timestamp);
    }

    function totalCurrents() external view returns (uint256) {
        return currents.length;
    }
}
