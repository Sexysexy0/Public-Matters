// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AppSanctifier {
    struct AppAudit {
        string appName;
        string packageId;
        string emotionalTag;
        bool blessed;
        uint256 timestamp;
    }

    mapping(bytes32 => AppAudit) public audits;
    event AppBlessed(string appName, string emotionalTag, uint256 timestamp);
    event AppFlagged(string appName, string emotionalTag, uint256 timestamp);

    function auditApp(
        string memory appName,
        string memory packageId,
        string memory emotionalTag,
        bool bless
    ) public {
        bytes32 key = keccak256(abi.encodePacked(packageId));
        audits[key] = AppAudit(appName, packageId, emotionalTag, bless, block.timestamp);

        if (bless) {
            emit AppBlessed(appName, emotionalTag, block.timestamp);
        } else {
            emit AppFlagged(appName, emotionalTag, block.timestamp);
        }
    }

    function getAudit(string memory packageId) public view returns (AppAudit memory) {
        bytes32 key = keccak256(abi.encodePacked(packageId));
        return audits[key];
    }
}
