// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollchainWatchdogProtocol {
    address public steward;

    struct OperationLog {
        string actor;
        string action;
        string location;
        string mediaLink;
        uint256 timestamp;
        bool verified;
    }

    OperationLog[] public logs;

    event OperationLogged(string actor, string action, string location, string mediaLink);
    event OperationVerified(string actor, string action);

    constructor() {
        steward = msg.sender;
    }

    function logOperation(
        string memory actor,
        string memory action,
        string memory location,
        string memory mediaLink
    ) public {
        logs.push(OperationLog(actor, action, location, mediaLink, block.timestamp, false));
        emit OperationLogged(actor, action, location, mediaLink);
    }

    function verifyOperation(uint index) public {
        require(msg.sender == steward, "Only steward may verify");
        logs[index].verified = true;
        emit OperationVerified(logs[index].actor, logs[index].action);
    }

    function getLogs() public view returns (OperationLog[] memory) {
        return logs;
    }
}
