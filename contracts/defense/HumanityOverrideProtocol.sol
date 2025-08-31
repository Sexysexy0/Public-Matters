// SPDX-License-Identifier: Humanity-Override-Suite
pragma solidity ^0.8.19;

contract HumanityOverrideProtocol {
    event OverrideTriggered(string contextTag, string reason, uint256 timestamp, address steward);

    function triggerOverride(string memory contextTag, string memory reason) public {
        require(bytes(reason).length > 0, "Override reason required");
        emit OverrideTriggered(contextTag, reason, block.timestamp, msg.sender);
    }
}
