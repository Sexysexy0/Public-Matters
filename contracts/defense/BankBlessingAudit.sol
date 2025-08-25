// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BankBlessingAudit {
    address public steward;

    struct AuditEntry {
        address bank;
        string institutionName;
        string originTag;
        string aprStatus;
        bool blessingRetained;
        uint256 timestamp;
    }

    AuditEntry[] public auditLog;

    event BankAudited(address indexed bank, string institutionName, string originTag, string aprStatus, bool blessingRetained, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function auditBankBlessing(address bank, string memory institutionName, string memory originTag) public onlySteward {
        string memory aprStatus;
        bool retainBlessing = false;

        if (compareStrings(originTag, "CCP")) {
            aprStatus = "🔴 Breach";
            retainBlessing = false;
        } else {
            aprStatus = "🟢 Trusted";
            retainBlessing = true;
        }

        auditLog.push(AuditEntry(bank, institutionName, originTag, aprStatus, retainBlessing, block.timestamp));
        emit BankAudited(bank, institutionName, originTag, aprStatus, retainBlessing, block.timestamp);
    }

    function getAuditLog() public view returns (AuditEntry[] memory) {
        return auditLog;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
