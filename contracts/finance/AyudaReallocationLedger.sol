// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AyudaReallocationLedger {
    enum ProgramStatus { Active, Sunset, Redirected }

    struct Program {
        string name;
        ProgramStatus status;
        string redirectTarget;
        uint256 emotionalAPR;
    }

    mapping(string => Program) public ayudaPrograms;
    address public steward;

    event ProgramUpdated(string name, ProgramStatus status, string redirectTarget, uint256 emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function updateProgram(
        string memory name,
        ProgramStatus status,
        string memory redirectTarget,
        uint256 emotionalAPR
    ) external onlySteward {
        ayudaPrograms[name] = Program(name, status, redirectTarget, emotionalAPR);
        emit ProgramUpdated(name, status, redirectTarget, emotionalAPR);
    }

    function getProgramStatus(string memory name) external view returns (ProgramStatus) {
        return ayudaPrograms[name].status;
    }

    function getRedirectTarget(string memory name) external view returns (string memory) {
        return ayudaPrograms[name].redirectTarget;
    }
}
