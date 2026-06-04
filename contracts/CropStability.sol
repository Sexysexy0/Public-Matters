// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CropStability
/// @notice Covenant contract to safeguard agricultural resilience and food security in Mindanao
contract CropStability {
    address public owner;

    struct StabilityProgram {
        string crop;         // e.g. "Banana", "Rice", "Cacao"
        string safeguard;    // e.g. "Climate-Resilient Seeds", "Irrigation Upgrade"
        uint256 budget;      // allocated budget for program
        uint256 timestamp;
    }

    StabilityProgram[] public programs;

    event ProgramLogged(string crop, string safeguard, uint256 budget, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new crop stability program
    function logProgram(string memory crop, string memory safeguard, uint256 budget) public onlyOwner {
        StabilityProgram memory newProgram = StabilityProgram(crop, safeguard, budget, block.timestamp);
        programs.push(newProgram);
        emit ProgramLogged(crop, safeguard, budget, block.timestamp);
    }

    function getProgram(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        StabilityProgram memory p = programs[index];
        return (p.crop, p.safeguard, p.budget, p.timestamp);
    }

    function getProgramCount() public view returns (uint256) {
        return programs.length;
    }
}
