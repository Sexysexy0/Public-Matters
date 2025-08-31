// SPDX-License-Identifier: Mythic-Style-Hash
pragma solidity ^0.8.19;

contract StyleHashGenerator {
    event StyleHashCreated(address steward, string styleHash, string toneDescriptor);

    function generateStyleHash(string memory writingSample, string memory toneDescriptor) public pure returns (string memory) {
        bytes32 hash = keccak256(abi.encodePacked(writingSample, toneDescriptor));
        return toHexString(hash);
    }

    function toHexString(bytes32 data) internal pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint i = 0; i < 32; i++) {
            str[i*2] = hexChars[uint8(data[i] >> 4)];
            str[i*2+1] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }
}
