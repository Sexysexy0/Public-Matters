// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract QuantumTalentRegistry {
    struct Talent {
        string name;
        string role; // Scholar, Mentor, Steward
        string specialty; // Quantum Computing, QKD, Civic AI, etc.
        string sanctum; // Barangay, University, or Global Node
        uint256 emotionalAPR; // Empathy, resonance, mythic clarity
        uint256 timestamp;
        address steward;
    }

    Talent[] public registry;

    event TalentRegistered(string name, string role, string specialty, string sanctum, uint256 emotionalAPR);

    function registerTalent(
        string memory name,
        string memory role,
        string memory specialty,
        string memory sanctum,
        uint256 emotionalAPR
    ) public {
        registry.push(Talent(name, role, specialty, sanctum, emotionalAPR, block.timestamp, msg.sender));
        emit TalentRegistered(name, role, specialty, sanctum, emotionalAPR);
    }

    function getAllTalents() public view returns (Talent[] memory) {
        return registry;
    }
}
