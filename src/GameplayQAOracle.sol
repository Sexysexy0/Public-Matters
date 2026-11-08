// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title GameplayQAOracle
 * @notice Tracks bug reports from players and patch status from the devs.
 */
contract GameplayQAOracle {
    OperatorPrivileges public immutable privileges;

    enum BugStatus { OPEN, PATCHING, RESOLVED }

    struct BugReport {
        bytes32 id;
        bytes32 reporterHash;
        bytes32 bugDescriptionHash; // e.g., "Boat flips mid-battle"
        BugStatus status;
        uint256 timestamp;
    }

    mapping(bytes32 => BugReport) public bugs;
    uint256 public totalBugs;

    event BugReported(bytes32 indexed id, bytes32 indexed reporterHash, bytes32 bugDescriptionHash);
    event BugStatusUpdated(bytes32 indexed id, BugStatus newStatus);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function reportBug(bytes32 reporterHash, bytes32 bugDescriptionHash) external returns (bytes32) {
        bytes32 id = keccak256(abi.encode(reporterHash, bugDescriptionHash, block.timestamp, totalBugs));
        require(bugs[id].timestamp == 0, "Bug exists");

        totalBugs++;
        bugs[id] = BugReport({
            id: id,
            reporterHash: reporterHash,
            bugDescriptionHash: bugDescriptionHash,
            status: BugStatus.OPEN,
            timestamp: block.timestamp
        });

        emit BugReported(id, reporterHash, bugDescriptionHash);
        return id;
    }

    function getBug(bytes32 id) external view returns (BugReport memory) {
        return bugs[id];
    }

    function updateBugStatus(bytes32 bugId, BugStatus newStatus) external onlyOperator {
        BugReport storage b = bugs[bugId];
        require(b.timestamp != 0, "Bug not found");
        b.status = newStatus;
        emit BugStatusUpdated(bugId, newStatus);
    }
}
