// EducationProtocol.sol
pragma solidity ^0.8.0;

contract EducationProtocol {
    struct Program {
        uint256 id;
        string domain;       // e.g. "STEM"
        string description;  // e.g. "Scholarship for engineering students"
        bool active;
        uint256 timestamp;
    }

    uint256 public programCount;
    mapping(uint256 => Program) public programs;

    event ProgramActivated(uint256 id, string domain, string description);

    function activateProgram(string memory domain, string memory description) public {
        programCount++;
        programs[programCount] = Program(programCount, domain, description, true, block.timestamp);
        emit ProgramActivated(programCount, domain, description);
    }
}
