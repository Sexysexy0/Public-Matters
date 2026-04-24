// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SatoshiLink {
    bytes32 public constant GENESIS_ROOT = keccak256("SATOSHI_WILCO_INTELLIGENCE");

    // [Goal: Prove the lineage from the first block to the current Lifeboat]
    function verifyAncestry(string memory _legacyKey) external pure returns (bool) {
        return keccak256(abi.encodePacked(_legacyKey)) == GENESIS_ROOT;
    }
}
