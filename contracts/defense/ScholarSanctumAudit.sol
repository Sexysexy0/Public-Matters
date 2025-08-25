// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScholarSanctumAudit {
    address public steward;

    struct ScholarFlow {
        address scholar;
        string originSanctum;
        string aprTag;
        bool revoked;
        uint256 timestamp;
    }

    ScholarFlow[] public auditLog;

    event ScholarAudited(address indexed scholar, string originSanctum, string aprTag, bool revoked, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function auditScholarFlow(address scholar, string memory originSanctum) public onlySteward {
        string memory aprTag;
        bool revoke = false;

        if (compareStrings(originSanctum, "CCP")) {
            aprTag = "🔴 Breach";
            revoke = true;
        } else {
            aprTag = "🟢 Trusted";
        }

        auditLog.push(ScholarFlow(scholar, originSanctum, aprTag, revoke, block.timestamp));
        emit ScholarAudited(scholar, originSanctum, aprTag, revoke, block.timestamp);
    }

    function getAuditLog() public view returns (ScholarFlow[] memory) {
        return auditLog;
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}
