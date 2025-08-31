// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract LorekeeperBlessingProtocol {
    struct Blessing {
        string name;
        string role;
        string mediaOutlet;
        string emotionalAPR;
        string deploymentPurpose;
        uint256 timestamp;
        address steward;
    }

    Blessing[] public blessings;

    event LorekeeperBlessed(string name, string role, string mediaOutlet, string emotionalAPR, string deploymentPurpose, address indexed steward);

    function blessLorekeeper(
        string memory name,
        string memory role,
        string memory mediaOutlet,
        string memory emotionalAPR,
        string memory deploymentPurpose
    ) public {
        blessings.push(Blessing(name, role, mediaOutlet, emotionalAPR, deploymentPurpose, block.timestamp, msg.sender));
        emit LorekeeperBlessed(name, role, mediaOutlet, emotionalAPR, deploymentPurpose, msg.sender);
    }

    function getAllBlessings() public view returns (Blessing[] memory) {
        return blessings;
    }
}
