// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract ScrollOfCampaignAudit {
    struct CampaignScroll {
        string promise;
        bool fulfilled;
        uint256 timestamp;
        string evidence;
    }

    mapping(address => CampaignScroll[]) public campaignLog;
    event PromiseLogged(address indexed candidate, string promise, bool fulfilled, string evidence, uint256 timestamp);

    function logPromise(address candidate, string calldata promise, bool fulfilled, string calldata evidence) external {
        campaignLog[candidate].push(CampaignScroll(promise, fulfilled, block.timestamp, evidence));
        emit PromiseLogged(candidate, promise, fulfilled, evidence, block.timestamp);
    }

    function getPromises(address candidate) external view returns (CampaignScroll[] memory) {
        return campaignLog[candidate];
    }

    function getFulfilledCount(address candidate) external view returns (uint256 count) {
        CampaignScroll[] memory logs = campaignLog[candidate];
        for (uint256 i = 0; i < logs.length; i++) {
            if (logs[i].fulfilled) count++;
        }
    }
}
