// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPMergeValidator {
    enum IPType { Legacy, Collaborative, Reserved, Cultural }
    enum MergeStatus { Eligible, Blocked, Conditional }

    struct IPRecord {
        uint256 id;
        string title;
        address owner;
        IPType ipType;
        MergeStatus mergeStatus;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => IPRecord) public ipRegistry;
    uint256 public ipCount;

    event IPLogged(uint256 id, string title, MergeStatus mergeStatus);
    event MergeAttempt(uint256 id, bool approved, string reason);

    function logIP(
        string memory title,
        address owner,
        IPType ipType,
        MergeStatus mergeStatus,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        ipRegistry[ipCount] = IPRecord(
            ipCount,
            title,
            owner,
            ipType,
            mergeStatus,
            clauseReference,
            timestamp
        );
        emit IPLogged(ipCount, title, mergeStatus);
        ipCount++;
    }

    function attemptMerge(uint256 id) public returns (bool approved, string memory reason) {
        require(id < ipCount, "Invalid IP ID");
        IPRecord memory record = ipRegistry[id];

        if (record.mergeStatus == MergeStatus.Blocked) {
            emit MergeAttempt(id, false, "Merge blocked by sovereignty clause");
            return (false, "Merge blocked by sovereignty clause");
        } else if (record.mergeStatus == MergeStatus.Conditional) {
            emit MergeAttempt(id, false, "Merge requires cultural or creator consent");
            return (false, "Merge requires cultural or creator consent");
        } else {
            emit MergeAttempt(id, true, "Merge approved under shared equity clause");
            return (true, "Merge approved under shared equity clause");
        }
    }

    function getIP(uint256 id) public view returns (IPRecord memory) {
        return ipRegistry[id];
    }
}
