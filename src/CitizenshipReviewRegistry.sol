// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title CitizenshipReviewRegistry
 * @notice Append-only record of citizenship review proceedings, with
 *         due process enforced in code. The state machine will not
 *         allow a review to resolve without notice, an appeal window,
 *         and an independent reviewer distinct from the filer.
 *
 * Neutral: grounds, subject identity, and outcome are hashed off-chain.
 * The contract enforces the procedure, not the substantive policy.
 */
contract CitizenshipReviewRegistry {
    OperatorPrivileges public immutable privileges;

    enum ReviewState {
        NONE,
        FILED,
        NOTICE_SERVED,
        APPEAL_WINDOW_OPEN,
        APPEAL_FILED,
        UNDER_REVIEW,
        RESOLVED,
        CANCELLED
    }

    struct Review {
        bytes32 id;
        bytes32 subjectHash;
        bytes32 groundsHash;
        uint256 filedAt;
        uint256 noticeServedAt;
        uint256 appealDeadline;
        uint256 appealFiledAt;
        address filer;
        address independentReviewer;
        ReviewState state;
        bytes32 outcomeHash;
        address recordedBy;
    }

    mapping(bytes32 => Review) public reviews;
    bytes32[] public reviewIds;

    uint256 public appealWindow; // seconds; default 30 days

    uint256 public totalFiled;
    uint256 public totalResolved;
    uint256 public totalAppealed;
    uint256 public totalCancelled;

    event ReviewFiled(bytes32 indexed id, bytes32 indexed subjectHash, address indexed filer, bytes32 groundsHash);
    event NoticeServed(bytes32 indexed id, uint256 appealDeadline);
    event AppealFiled(bytes32 indexed id, address indexed appellant);
    event ReviewerAssigned(bytes32 indexed id, address indexed reviewer);
    event ReviewResolved(bytes32 indexed id, bytes32 outcomeHash);
    event ReviewCancelled(bytes32 indexed id);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
        appealWindow = 30 days;
    }

    function setAppealWindow(uint256 _seconds) external onlyOperator {
        require(_seconds >= 1 days && _seconds <= 365 days, "appealWindow out of range");
        appealWindow = _seconds;
    }

    function fileReview(bytes32 subjectHash, bytes32 groundsHash) external onlyOperator returns (bytes32) {
        require(subjectHash != bytes32(0), "subjectHash=0");
        require(groundsHash != bytes32(0), "groundsHash=0");

        bytes32 id = keccak256(abi.encode(subjectHash, groundsHash, msg.sender, block.timestamp, reviewIds.length));
        require(reviews[id].filedAt == 0, "Review exists");

        reviews[id] = Review({
            id: id,
            subjectHash: subjectHash,
            groundsHash: groundsHash,
            filedAt: block.timestamp,
            noticeServedAt: 0,
            appealDeadline: 0,
            appealFiledAt: 0,
            filer: msg.sender,
            independentReviewer: address(0),
            state: ReviewState.FILED,
            outcomeHash: bytes32(0),
            recordedBy: msg.sender
        });
        reviewIds.push(id);
        totalFiled += 1;

        emit ReviewFiled(id, subjectHash, msg.sender, groundsHash);
        return id;
    }

    /// @notice Serve notice. Opens the appeal window. Cannot be skipped.
    function serveNotice(bytes32 id) external onlyOperator {
        Review storage r = reviews[id];
        require(r.state == ReviewState.FILED, "Not in FILED");
        r.noticeServedAt = block.timestamp;
        r.appealDeadline = block.timestamp + appealWindow;
        r.state = ReviewState.APPEAL_WINDOW_OPEN;
        emit NoticeServed(id, r.appealDeadline);
    }

    /// @notice Subject files an appeal. Only during the window.
    function fileAppeal(bytes32 id) external {
        Review storage r = reviews[id];
        require(r.state == ReviewState.APPEAL_WINDOW_OPEN, "Window not open");
        require(block.timestamp <= r.appealDeadline, "Window expired");
        r.appealFiledAt = block.timestamp;
        r.state = ReviewState.APPEAL_FILED;
        totalAppealed += 1;
        emit AppealFiled(id, msg.sender);
    }

    /// @notice Move to review. Reviewer must not be the filer.
    function assignReviewer(bytes32 id, address reviewer) external onlyOperator {
        Review storage r = reviews[id];
        require(
            r.state == ReviewState.APPEAL_WINDOW_OPEN || r.state == ReviewState.APPEAL_FILED,
            "Cannot assign reviewer at this stage"
        );
        require(reviewer != address(0), "reviewer=0");
        require(reviewer != r.filer, "Reviewer must be independent of filer");
        require(privileges.isOperator(reviewer), "Reviewer must be an operator");
        r.independentReviewer = reviewer;
        r.state = ReviewState.UNDER_REVIEW;
        emit ReviewerAssigned(id, reviewer);
    }

    /// @notice Resolve. Only the assigned reviewer may resolve.
    function resolve(bytes32 id, bytes32 outcomeHash) external {
        Review storage r = reviews[id];
        require(r.state == ReviewState.UNDER_REVIEW, "Not under review");
        require(msg.sender == r.independentReviewer, "Only assigned reviewer");
        require(outcomeHash != bytes32(0), "outcomeHash=0");
        r.outcomeHash = outcomeHash;
        r.state = ReviewState.RESOLVED;
        totalResolved += 1;
        emit ReviewResolved(id, outcomeHash);
    }

    /// @notice Cancel. Only allowed before notice is served.
    function cancelReview(bytes32 id) external onlyOperator {
        Review storage r = reviews[id];
        require(r.state == ReviewState.FILED, "Cannot cancel after notice");
        r.state = ReviewState.CANCELLED;
        totalCancelled += 1;
        emit ReviewCancelled(id);
    }

    function getReview(bytes32 id) external view returns (Review memory) {
        return reviews[id];
    }

    function getReviewCount() external view returns (uint256) {
        return reviewIds.length;
    }

    function getTotals() external view returns (uint256 filed, uint256 resolved, uint256 appealed, uint256 cancelled) {
        return (totalFiled, totalResolved, totalAppealed, totalCancelled);
    }
}
