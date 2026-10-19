// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title ImmigrationProcessingRegistry
 * @notice Append-only record of immigration application processing.
 *         Neutral: does not encode policy. Records filing, decisions,
 *         and appeals so citizens can query backlog, timelines, and
 *         decision rates per office and category.
 *
 * Office, category, applicant, and policy are all hashed off-chain.
 * The contract does not know what "work-visa" or "RDO-UK-01" means.
 * It only records that a record exists, who filed it, and when.
 */
contract ImmigrationProcessingRegistry {
    OperatorPrivileges public immutable privileges;

    enum Outcome {
        FILED,
        APPROVED,
        DENIED,
        APPEALED,
        GRANTED_ON_APPEAL,
        WITHDRAWN
    }

    struct Application {
        bytes32 id;
        bytes32 officeHash;
        bytes32 categoryHash;
        bytes32 applicantHash;
        bytes32 policyHash;
        uint256 filedAt;
        uint256 decidedAt;
        Outcome outcome;
        address recordedBy;
        bytes32 evidenceHash;
    }

    mapping(bytes32 => Application) public applications;
    bytes32[] public applicationIds;

    mapping(bytes32 => uint256) public filedByOffice;
    mapping(bytes32 => uint256) public approvedByOffice;
    mapping(bytes32 => uint256) public deniedByOffice;
    mapping(bytes32 => uint256) public appealedByOffice;
    mapping(bytes32 => mapping(bytes32 => uint256)) public filedByCategory;

    uint256 public totalFiled;
    uint256 public totalApproved;
    uint256 public totalDenied;
    uint256 public totalAppealed;
    uint256 public totalGrantedOnAppeal;

    event ApplicationFiled(
        bytes32 indexed id,
        bytes32 indexed officeHash,
        bytes32 indexed categoryHash,
        bytes32 policyHash,
        address recordedBy,
        bytes32 evidenceHash
    );
    event DecisionRecorded(bytes32 indexed id, Outcome outcome, address recordedBy, bytes32 evidenceHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function fileApplication(
        bytes32 officeHash,
        bytes32 categoryHash,
        bytes32 applicantHash,
        bytes32 policyHash,
        bytes32 evidenceHash
    ) external onlyOperator returns (bytes32) {
        require(officeHash != bytes32(0), "officeHash=0");
        require(categoryHash != bytes32(0), "categoryHash=0");
        require(applicantHash != bytes32(0), "applicantHash=0");

        bytes32 id = keccak256(
            abi.encode(
                officeHash, categoryHash, applicantHash, policyHash, msg.sender, block.timestamp, applicationIds.length
            )
        );
        require(applications[id].filedAt == 0, "Application exists");

        applications[id] = Application({
            id: id,
            officeHash: officeHash,
            categoryHash: categoryHash,
            applicantHash: applicantHash,
            policyHash: policyHash,
            filedAt: block.timestamp,
            decidedAt: 0,
            outcome: Outcome.FILED,
            recordedBy: msg.sender,
            evidenceHash: evidenceHash
        });
        applicationIds.push(id);

        filedByOffice[officeHash] += 1;
        filedByCategory[officeHash][categoryHash] += 1;
        totalFiled += 1;

        emit ApplicationFiled(id, officeHash, categoryHash, policyHash, msg.sender, evidenceHash);
        return id;
    }

    function recordDecision(bytes32 applicationId, Outcome outcome, bytes32 evidenceHash) external onlyOperator {
        Application storage a = applications[applicationId];
        require(a.filedAt != 0, "Application not found");
        require(a.decidedAt == 0, "Already decided");
        require(outcome != Outcome.FILED, "Invalid outcome");
        require(outcome != Outcome.APPEALED, "Use recordAppeal for appeal");

        a.decidedAt = block.timestamp;
        a.outcome = outcome;

        if (outcome == Outcome.APPROVED) {
            approvedByOffice[a.officeHash] += 1;
            totalApproved += 1;
        } else if (outcome == Outcome.DENIED) {
            deniedByOffice[a.officeHash] += 1;
            totalDenied += 1;
        } else if (outcome == Outcome.GRANTED_ON_APPEAL) {
            approvedByOffice[a.officeHash] += 1;
            totalGrantedOnAppeal += 1;
        } else if (outcome == Outcome.WITHDRAWN) {
            // no aggregate change
        }

        emit DecisionRecorded(applicationId, outcome, msg.sender, evidenceHash);
    }

    function recordAppeal(bytes32 applicationId, Outcome finalOutcome, bytes32 evidenceHash) external onlyOperator {
        Application storage a = applications[applicationId];
        require(a.filedAt != 0, "Application not found");
        require(a.outcome == Outcome.DENIED, "Only denied applications can be appealed");
        require(finalOutcome == Outcome.GRANTED_ON_APPEAL || finalOutcome == Outcome.DENIED, "Invalid appeal outcome");

        appealedByOffice[a.officeHash] += 1;
        totalAppealed += 1;

        if (finalOutcome == Outcome.GRANTED_ON_APPEAL) {
            a.outcome = Outcome.GRANTED_ON_APPEAL;
            approvedByOffice[a.officeHash] += 1;
            totalGrantedOnAppeal += 1;
        } else {
            a.outcome = Outcome.APPEALED;
        }

        emit DecisionRecorded(applicationId, a.outcome, msg.sender, evidenceHash);
    }

    function getApplication(bytes32 id) external view returns (Application memory) {
        return applications[id];
    }

    function getApplicationCount() external view returns (uint256) {
        return applicationIds.length;
    }

    /// @notice Share of decisions that approved, in bps. Excludes pending.
    function getOfficeApprovalRate(bytes32 officeHash) external view returns (uint256) {
        uint256 filed = filedByOffice[officeHash];
        if (filed == 0) return 0;
        return (approvedByOffice[officeHash] * 10000) / filed;
    }

    function getOfficeStats(bytes32 officeHash)
        external
        view
        returns (uint256 filed, uint256 approved, uint256 denied, uint256 appealed)
    {
        return (
            filedByOffice[officeHash],
            approvedByOffice[officeHash],
            deniedByOffice[officeHash],
            appealedByOffice[officeHash]
        );
    }

    function getCategoryCount(bytes32 officeHash, bytes32 categoryHash) external view returns (uint256) {
        return filedByCategory[officeHash][categoryHash];
    }

    function getTotals()
        external
        view
        returns (uint256 filed, uint256 approved, uint256 denied, uint256 appealed, uint256 grantedOnAppeal)
    {
        return (totalFiled, totalApproved, totalDenied, totalAppealed, totalGrantedOnAppeal);
    }
}
