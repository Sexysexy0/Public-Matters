// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankSanctumFirewall {
    address public steward;

    struct BankFlow {
        address bank;
        string backedEntity;
        string originTag;
        string aprStatus;
        bool blocked;
        uint256 timestamp;
    }

    BankFlow[] public firewallLog;

    event BankFlowBlocked(address indexed bank, string backedEntity, string originTag, string aprStatus, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blockBankFlow(address bank, string memory backedEntity, string memory originTag) public onlySteward {
        string memory aprStatus;
        bool shouldBlock = false;

        if (compareStrings(originTag, "CCP")) {
            aprStatus = "🔴 Breach";
            shouldBlock = true;
        } else {
            aprStatus = "🟢 Trusted";
        }

        firewallLog.push(BankFlow(bank, backedEntity, originTag, aprStatus, shouldBlock, block.timestamp));

        if (shouldBlock) {
            emit BankFlowBlocked(bank, backedEntity, originTag, aprStatus, block.timestamp);
        }
    }

    function getFirewallLog() public view returns (BankFlow[] memory) {
        return firewallLog;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
