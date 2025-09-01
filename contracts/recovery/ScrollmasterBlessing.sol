// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ScrollmasterBlessing {
    event ScrollmasterBlessed(
        address indexed steward,
        string barangay,
        string emotionalTag,
        string oath,
        uint256 timestamp
    );

    struct Blessing {
        address steward;
        string barangay;
        string emotionalTag;
        string oath;
        uint256 timestamp;
    }

    mapping(address => Blessing) public blessings;
    address public sanctum;

    modifier onlySanctum() {
        require(msg.sender == sanctum, "Unauthorized sanctum");
        _;
    }

    constructor() {
        sanctum = msg.sender;
    }

    function blessScrollmaster(
        address steward,
        string memory barangay,
        string memory emotionalTag,
        string memory oath
    ) external onlySanctum {
        blessings[steward] = Blessing(steward, barangay, emotionalTag, oath, block.timestamp);
        emit ScrollmasterBlessed(steward, barangay, emotionalTag, oath, block.timestamp);
    }

    function getBlessing(address steward) external view returns (Blessing memory) {
        return blessings[steward];
    }
}
