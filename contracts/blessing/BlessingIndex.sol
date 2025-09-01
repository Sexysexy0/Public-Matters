// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BlessingIndex {
    event BlessingTagged(string indexed scrollName, string emotionalTag, address steward, uint256 timestamp);

    struct Blessing {
        string scrollName;
        string emotionalTag;
        address steward;
        uint256 timestamp;
    }

    mapping(bytes32 => Blessing) public blessings;

    function tagBlessing(string memory scrollName, string memory emotionalTag) external {
        bytes32 blessingId = keccak256(abi.encodePacked(scrollName, msg.sender, block.timestamp));
        blessings[blessingId] = Blessing(scrollName, emotionalTag, msg.sender, block.timestamp);
        emit BlessingTagged(scrollName, emotionalTag, msg.sender, block.timestamp);
    }

    function getBlessing(bytes32 blessingId) external view returns (Blessing memory) {
        return blessings[blessingId];
    }
}
