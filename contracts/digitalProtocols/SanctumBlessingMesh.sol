// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SanctumBlessingMesh {
    struct SanctumNode {
        string sanctumName;
        string gridPartner;
        uint256 emotionalAPR;
        bool blessingConfirmed;
        uint256 timestamp;
        address steward;
    }

    SanctumNode[] public mesh;

    event SanctumLinked(string sanctumName, string gridPartner, uint256 emotionalAPR);

    function linkSanctum(
        string memory sanctumName,
        string memory gridPartner,
        uint256 emotionalAPR
    ) public {
        mesh.push(SanctumNode(sanctumName, gridPartner, emotionalAPR, true, block.timestamp, msg.sender));
        emit SanctumLinked(sanctumName, gridPartner, emotionalAPR);
    }

    function getMesh() public view returns (SanctumNode[] memory) {
        return mesh;
    }
}
