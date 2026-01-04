pragma solidity ^0.8.20;

contract DriverIntegrityProtocol {
    address public admin;

    struct Driver {
        string name;         // e.g. kernel driver, minifilter
        string signature;    // e.g. valid, revoked, compromised
        uint256 timestamp;
    }

    Driver[] public drivers;

    event DriverLogged(string name, string signature, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDriver(string calldata name, string calldata signature) external onlyAdmin {
        drivers.push(Driver(name, signature, block.timestamp));
        emit DriverLogged(name, signature, block.timestamp);
    }

    function totalDrivers() external view returns (uint256) {
        return drivers.length;
    }
}
