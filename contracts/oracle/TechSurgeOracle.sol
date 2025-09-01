// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract TechSurgeOracle {
    event SurgeLogged(
        string brand,
        string techEvent,
        string region,
        string emotionalTag,
        uint256 timestamp
    );

    struct TechSurge {
        string brand;
        string techEvent;
        string region;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(bytes32 => TechSurge) public surges;

    function logSurge(
        string memory brand,
        string memory techEvent,
        string memory region,
        string memory emotionalTag
    ) external {
        bytes32 surgeId = keccak256(abi.encodePacked(brand, techEvent, block.timestamp));
        surges[surgeId] = TechSurge(brand, techEvent, region, emotionalTag, block.timestamp);
        emit SurgeLogged(brand, techEvent, region, emotionalTag, block.timestamp);
    }

    function getSurge(bytes32 surgeId) external view returns (TechSurge memory) {
        return surges[surgeId];
    }
}
