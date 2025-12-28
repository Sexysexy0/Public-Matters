// contracts/MilitaryModernization.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MilitaryModernization
 * @notice Logs modernization efforts in defense systems and munitions.
 */
contract MilitaryModernization {
    address public admin;

    struct Program {
        string name;        // "NextGenFighter", "HypersonicMissiles", "CyberDefense"
        string status;      // "Active", "Pending", "Completed"
        uint256 budget;     // in millions USD
        uint256 timestamp;
    }

    Program[] public programs;

    event ProgramLogged(string name, string status, uint256 budget, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logProgram(string calldata name, string calldata status, uint256 budget) external onlyAdmin {
        programs.push(Program(name, status, budget, block.timestamp));
        emit ProgramLogged(name, status, budget, block.timestamp);
    }

    function totalPrograms() external view returns (uint256) { return programs.length; }

    function getProgram(uint256 id) external view returns (Program memory) {
        require(id < programs.length, "Invalid id");
        return programs[id];
    }
}
