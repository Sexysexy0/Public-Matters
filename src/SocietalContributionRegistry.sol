// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";
import "./CivicSovereigntyRegistry.sol";

/**
 * @title SocietalContributionRegistry
 * @notice Objective, non-partisan tracking of civic contributions.
 *         Replaces ideological noise with verifiable on-chain merit.
 */
contract SocietalContributionRegistry {
    OperatorPrivileges public immutable privileges;
    CivicSovereigntyRegistry public immutable civic;

    enum ContributionType { CAREGIVING, CIVIC_DUTY, SKILL_BUILDING, COMMUNITY_BUILDING }

    mapping(address => mapping(ContributionType => uint256)) public contributionPoints;
    mapping(address => uint256) public totalContributionScore;

    event ContributionRecorded(address indexed citizen, ContributionType indexed cType, uint256 points, string reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges, address _civic) {
        require(_privileges != address(0), "privileges=0");
        require(_civic != address(0), "civic=0");
        privileges = OperatorPrivileges(_privileges);
        civic = CivicSovereigntyRegistry(_civic);
    }

    /**
     * @notice Record a verifiable contribution to society.
     * @dev Only registered citizens in CivicSovereigntyRegistry can earn points.
     */
    function recordContribution(
        address citizen,
        ContributionType cType,
        uint256 points,
        string calldata reason
    ) external onlyOperator {
        // Check if citizen is registered in CivicSovereigntyRegistry
        CivicSovereigntyRegistry.Citizen memory c = civic.getCitizen(citizen);
        require(c.isRegistered, "Citizen not registered");

        contributionPoints[citizen][cType] += points;
        totalContributionScore[citizen] += points;

        emit ContributionRecorded(citizen, cType, points, reason);
    }

    function getScore(address citizen) external view returns (uint256) {
        return totalContributionScore[citizen];
    }
}
