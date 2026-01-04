pragma solidity ^0.8.20;

contract CommunityResilienceProtocol {
    address public admin;
    struct Program { string project; string benefit; uint256 timestamp; }
    Program[] public programs;
    event ProgramLogged(string project, string benefit, uint256 timestamp);
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }
    function logProgram(string calldata project, string calldata benefit) external onlyAdmin {
        programs.push(Program(project, benefit, block.timestamp));
        emit ProgramLogged(project, benefit, block.timestamp);
    }
}
