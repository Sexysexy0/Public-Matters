// SPDX-License-Identifier: Mythic-Ethics-Suite
pragma solidity ^0.8.19;

contract AIResponseAudit {
    struct ResponseLog {
        string contentHash;
        string contextTag;
        uint256 emotionalAPR;
        bool flagged;
        string stewardFeedback;
        uint256 timestamp;
        address steward;
    }

    ResponseLog[] public logs;

    event HarmfulResponseFlagged(string contextTag, uint256 emotionalAPR, string feedback);

    function logResponse(
        string memory contentHash,
        string memory contextTag,
        uint256 emotionalAPR,
        string memory stewardFeedback
    ) public {
        bool flagged = emotionalAPR < 50;
        logs.push(ResponseLog(contentHash, contextTag, emotionalAPR, flagged, stewardFeedback, block.timestamp, msg.sender));
        if (flagged) {
            emit HarmfulResponseFlagged(contextTag, emotionalAPR, stewardFeedback);
        }
    }

    function getLogs() public view returns (ResponseLog[] memory) {
        return logs;
    }
}
