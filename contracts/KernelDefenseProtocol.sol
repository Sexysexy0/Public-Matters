pragma solidity ^0.8.20;

contract KernelDefenseProtocol {
    address public admin;

    struct Defense {
        string system;       // e.g. Windows, Linux
        string method;       // e.g. driver monitoring, minifilter audit
        string status;       // e.g. active, patched, pending
        uint256 timestamp;
    }

    Defense[] public defenses;

    event DefenseLogged(string system, string method, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDefense(string calldata system, string calldata method, string calldata status) external onlyAdmin {
        defenses.push(Defense(system, method, status, block.timestamp));
        emit DefenseLogged(system, method, status, block.timestamp);
    }

    function totalDefenses() external view returns (uint256) {
        return defenses.length;
    }
}
