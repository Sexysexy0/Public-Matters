// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract ScrollchainWitnessLedger {
    address public stewardVinvin;

    struct ActionLog {
        string actionType;
        string emotionalTag;
        uint timestamp;
        address agent;
    }

    ActionLog[] public logs;

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function logAction(string memory actionType, string memory emotionalTag) public {
        logs.push(ActionLog({
            actionType: actionType,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp,
            agent: msg.sender
        }));
    }

    function getLogs() public view returns (ActionLog[] memory) {
        return logs;
    }
}
