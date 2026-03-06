// PublicLiteracyProtocol.sol
pragma solidity ^0.8.0;

contract PublicLiteracyProtocol {
    struct Program {
        uint256 id;
        string initiative; // e.g. "Media Literacy Curriculum"
        string safeguard;  // e.g. "Strengthen critical thinking and media literacy"
        uint256 timestamp;
    }

    uint256 public programCount;
    mapping(uint256 => Program) public programs;

    event ProgramLogged(uint256 id, string initiative, string safeguard);

    function logProgram(string memory initiative, string memory safeguard) public {
        programCount++;
        programs[programCount] = Program(programCount, initiative, safeguard, block.timestamp);
        emit ProgramLogged(programCount, initiative, safeguard);
    }
}
