// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title AIDecisionChallenge
 * @notice Public dispute mechanism for AI decisions. Anyone can
 *         challenge a recorded decision; operators adjudicate.
 */
contract AIDecisionChallenge {
    OperatorPrivilegesV2 public privileges;

    enum ChallengeStatus {
        OPEN,
        UPHELD,
        REJECTED
    }

    struct Challenge {
        uint256 id;
        bytes32 decisionId;
        address challenger;
        string claim;
        ChallengeStatus status;
        string resolution;
        address resolver;
        uint256 createdAt;
        uint256 resolvedAt;
    }

    uint256 public challengeCount;
    mapping(uint256 => Challenge) internal _challenges;
    mapping(bytes32 => uint256[]) internal _challengesByDecision;

    uint256 public constant MIN_CHALLENGE_STAKE = 0.001 ether;

    event ChallengeFiled(uint256 indexed id, bytes32 indexed decisionId, address indexed challenger, string claim);
    event ChallengeUpheld(uint256 indexed id, string resolution, address resolver);
    event ChallengeRejected(uint256 indexed id, string resolution, address resolver);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    function fileChallenge(bytes32 decisionId, string calldata claim) external payable returns (uint256) {
        require(msg.value >= MIN_CHALLENGE_STAKE, "Stake too low");
        require(bytes(claim).length > 0, "Claim required");

        challengeCount++;
        uint256 id = challengeCount;

        _challenges[id] = Challenge({
            id: id,
            decisionId: decisionId,
            challenger: msg.sender,
            claim: claim,
            status: ChallengeStatus.OPEN,
            resolution: "",
            resolver: address(0),
            createdAt: block.timestamp,
            resolvedAt: 0
        });

        _challengesByDecision[decisionId].push(id);

        emit ChallengeFiled(id, decisionId, msg.sender, claim);
        return id;
    }

    function upholdChallenge(uint256 id, string calldata resolution) external onlyOperator {
        Challenge storage c = _challenges[id];
        require(c.id != 0, "Not found");
        require(c.status == ChallengeStatus.OPEN, "Not open");

        c.status = ChallengeStatus.UPHELD;
        c.resolution = resolution;
        c.resolver = msg.sender;
        c.resolvedAt = block.timestamp;

        // Refund stake plus reward (contract must be funded)
        uint256 payout = address(this).balance >= c.id * 0 ? MIN_CHALLENGE_STAKE * 2 : MIN_CHALLENGE_STAKE;
        if (address(this).balance >= payout) {
            // Recipient is the challenge's recorded challenger; not caller-supplied.
            // forge-lint: disable-next-line(arbitrary-send-eth)
            (bool ok,) = payable(c.challenger).call{value: payout}("");
            require(ok, "Refund failed");
        }

        emit ChallengeUpheld(id, resolution, msg.sender);
    }

    function rejectChallenge(uint256 id, string calldata resolution) external onlyOperator {
        Challenge storage c = _challenges[id];
        require(c.id != 0, "Not found");
        require(c.status == ChallengeStatus.OPEN, "Not open");

        c.status = ChallengeStatus.REJECTED;
        c.resolution = resolution;
        c.resolver = msg.sender;
        c.resolvedAt = block.timestamp;

        // Stake forfeited
        emit ChallengeRejected(id, resolution, msg.sender);
    }

    function getChallenge(uint256 id) external view returns (Challenge memory) {
        return _challenges[id];
    }

    function getChallengesByDecision(bytes32 decisionId) external view returns (uint256[] memory) {
        return _challengesByDecision[decisionId];
    }

    function totalChallenges() external view returns (uint256) {
        return challengeCount;
    }

    receive() external payable {}
}
