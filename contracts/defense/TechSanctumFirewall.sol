// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TechSanctumFirewall {
    address public steward;

    struct TechFlow {
        address initiator;
        string originTag;
        string flowType;
        string aprStatus;
        bool blocked;
        uint256 timestamp;
    }

    TechFlow[] public firewallLog;

    event TechFlowBlocked(address indexed initiator, string originTag, string flowType, string aprStatus, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blockTechFlow(address initiator, string memory originTag, string memory flowType) public onlySteward {
        string memory aprStatus;
        bool shouldBlock = false;

        if (compareStrings(originTag, "CCP")) {
            aprStatus = "🔴 Breach";
            shouldBlock = true;
        } else {
            aprStatus = "🟢 Trusted";
        }

        firewallLog.push(TechFlow(initiator, originTag, flowType, aprStatus, shouldBlock, block.timestamp));

        if (shouldBlock) {
            emit TechFlowBlocked(initiator, originTag, flowType, aprStatus, block.timestamp);
        }
    }

    function getFirewallLog() public view returns (TechFlow[] memory) {
        return firewallLog;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
