// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract BlessingActivationLog {
    struct Blessing {
        address sanctum;
        string stewardTag;
        string emotionalTag;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event BlessingLogged(address sanctum, string stewardTag, string emotionalTag, uint256 timestamp);

    function logBlessing(address sanctum, string memory stewardTag, string memory emotionalTag) public {
        blessings.push(Blessing(sanctum, stewardTag, emotionalTag, block.timestamp));
        emit BlessingLogged(sanctum, stewardTag, emotionalTag, block.timestamp);
    }

    function getBlessing(uint256 index) public view returns (Blessing memory) {
        return blessings[index];
    }

    function totalBlessings() public view returns (uint256) {
        return blessings.length;
    }
}
