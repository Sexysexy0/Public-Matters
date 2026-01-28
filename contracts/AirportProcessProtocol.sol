pragma solidity ^0.8.20;

contract AirportProcessProtocol {
    address public admin;

    struct Process {
        string step;         // e.g. document check, interview
        string issue;        // e.g. offloading despite compliance
        string reform;       // e.g. streamline, transparency
        uint256 timestamp;
    }

    Process[] public processes;

    event ProcessLogged(string step, string issue, string reform, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logProcess(string calldata step, string calldata issue, string calldata reform) external onlyAdmin {
        processes.push(Process(step, issue, reform, block.timestamp));
        emit ProcessLogged(step, issue, reform, block.timestamp);
    }

    function totalProcesses() external view returns (uint256) {
        return processes.length;
    }
}
