pragma solidity ^0.8.20;

contract RootkitDetectionProtocol {
    address public admin;

    struct Rootkit {
        string name;         // e.g. ProjectConfiguration.sys, hidden driver
        string status;       // e.g. detected, mitigated, removed
        uint256 timestamp;
    }

    Rootkit[] public rootkits;

    event RootkitLogged(string name, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRootkit(string calldata name, string calldata status) external onlyAdmin {
        rootkits.push(Rootkit(name, status, block.timestamp));
        emit RootkitLogged(name, status, block.timestamp);
    }

    function totalRootkits() external view returns (uint256) {
        return rootkits.length;
    }
}
