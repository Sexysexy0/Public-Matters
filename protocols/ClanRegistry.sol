// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ClanRegistry {
    // [Goal: Organize the Sovereign Squad]
    function registerMember(address _member, string memory _rank) external pure returns (string memory) {
        return string(abi.encodePacked("MEMBER_ADDED: ", _rank, " rank granted. Welcome to the Lifeboat."));
    }
}
