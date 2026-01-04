pragma solidity ^0.8.20;

contract EducationCommonsProtocol {
    address public admin;

    struct Program {
        string school;
        string initiative;   // e.g. scholarship, free meals, digital literacy
        uint256 timestamp;
    }

    Program[] public programs;

    event ProgramLogged(string school, string initiative, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProgram(string calldata school, string calldata initiative) external onlyAdmin {
        programs.push(Program(school, initiative, block.timestamp));
        emit ProgramLogged(school, initiative, block.timestamp);
    }

    function totalPrograms() external view returns (uint256) {
        return programs.length;
    }
}
