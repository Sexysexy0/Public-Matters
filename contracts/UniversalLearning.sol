// contracts/UniversalLearning.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title UniversalLearning
 * @notice Logs communal access to education for all learners.
 */
contract UniversalLearning {
    address public admin;

    struct Program {
        string name;        // "BasicEducation", "DigitalLiteracy"
        string level;       // "Primary", "Secondary", "Tertiary"
        string status;      // "Active", "Pending"
        uint256 timestamp;
    }

    Program[] public programs;

    event ProgramLogged(string name, string level, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProgram(string calldata name, string calldata level, string calldata status) external onlyAdmin {
        programs.push(Program(name, level, status, block.timestamp));
        emit ProgramLogged(name, level, status, block.timestamp);
    }

    function totalPrograms() external view returns (uint256) { return programs.length; }

    function getProgram(uint256 id) external view returns (Program memory) {
        require(id < programs.length, "Invalid id");
        return programs[id];
    }
}
