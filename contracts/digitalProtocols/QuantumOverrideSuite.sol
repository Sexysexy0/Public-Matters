// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract QuantumOverrideSuite {
    struct OverrideEvent {
        string nodeName;
        string reason;
        uint256 emotionalAPR;
        bool overrideActivated;
        uint256 timestamp;
        address steward;
    }

    OverrideEvent[] public overrides;

    event OverrideTriggered(string nodeName, string reason, uint256 emotionalAPR);

    function triggerOverride(
        string memory nodeName,
        string memory reason,
        uint256 emotionalAPR
    ) public {
        require(emotionalAPR < 50, "Override not permitted: emotional APR stable");
        overrides.push(OverrideEvent(nodeName, reason, emotionalAPR, true, block.timestamp, msg.sender));
        emit OverrideTriggered(nodeName, reason, emotionalAPR);
    }

    function getAllOverrides() public view returns (OverrideEvent[] memory) {
        return overrides;
    }
}
