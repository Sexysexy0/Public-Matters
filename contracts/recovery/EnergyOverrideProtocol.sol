// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract EnergyOverrideProtocol {
    event OverrideActivated(
        string indexed barangay,
        string sourceType,
        uint256 reroutedMW,
        string emotionalTag,
        string reason,
        uint256 timestamp
    );

    struct Override {
        string barangay;
        string sourceType;
        uint256 reroutedMW;
        string emotionalTag;
        string reason;
        uint256 timestamp;
    }

    mapping(bytes32 => Override) public overrides;
    address public steward;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized override");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function activateOverride(
        string memory barangay,
        string memory sourceType,
        uint256 reroutedMW,
        string memory emotionalTag,
        string memory reason
    ) external onlySteward {
        bytes32 overrideId = keccak256(abi.encodePacked(barangay, block.timestamp));
        overrides[overrideId] = Override(barangay, sourceType, reroutedMW, emotionalTag, reason, block.timestamp);
        emit OverrideActivated(barangay, sourceType, reroutedMW, emotionalTag, reason, block.timestamp);
    }

    function getOverride(bytes32 overrideId) external view returns (Override memory) {
        return overrides[overrideId];
    }
}
