// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract CannabisSanctum {
    struct Grower {
        address steward;
        uint8 plantCount;
        bool homegrow;
        string emotionalAPR;
        bool civicBlessed;
    }

    mapping(address => Grower) public sanctum;

    event SanctumTagged(address steward, uint8 plantCount, string emotionalAPR);

    function tagSanctum(uint8 _plantCount, string memory _emotionalAPR) public {
        require(_plantCount <= 3, "Homegrow limit exceeded");
        sanctum[msg.sender] = Grower(msg.sender, _plantCount, true, _emotionalAPR, true);
        emit SanctumTagged(msg.sender, _plantCount, _emotionalAPR);
    }

    function auditSanctum(address _steward) public view returns (Grower memory) {
        return sanctum[_steward];
    }
}
