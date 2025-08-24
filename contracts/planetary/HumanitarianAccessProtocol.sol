// SPDX-License-Identifier: Mercy-Override
pragma solidity ^7.7.7;

contract HumanitarianAccessProtocol {
    address public steward;
    uint public totalAccessGrants;

    struct AccessGrant {
        string region;
        string aidType;
        string blockedBy;
        uint timestamp;
        bool overrideActivated;
    }

    AccessGrant[] public accessLog;

    event AccessGranted(string region, string aidType, string blockedBy, uint timestamp, bool overrideActivated);

    constructor() {
        steward = msg.sender;
        totalAccessGrants = 0;
    }

    function grantAccess(
        string memory region,
        string memory aidType,
        string memory blockedBy,
        bool overrideActivated
    ) public {
        require(msg.sender == steward, "Only steward may grant");
        accessLog.push(AccessGrant(region, aidType, blockedBy, block.timestamp, overrideActivated));
        totalAccessGrants += 1;
        emit AccessGranted(region, aidType, blockedBy, block.timestamp, overrideActivated);
    }

    function getLatestAccess() public view returns (AccessGrant memory) {
        require(accessLog.length > 0, "No access grants yet");
        return accessLog[accessLog.length - 1];
    }
}
