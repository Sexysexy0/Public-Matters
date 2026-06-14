// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title PersonalGrowthBetEscrow
 * @dev Hango sa artikulo ni Max Raskin sa Notre Dame JET (2023).
 * Gumagamit ng contract law at automated forfeitures bilang preemptive self-help 
 * para sa behavioral modification (e.g., weight loss, cessation of smoking).
 */
contract PersonalGrowthBetEscrow {
    address public sovereignContractor;
    IAuditHistory public auditHistory;

    struct BetProfile {
        uint256 betId;
        address creatorNode;
        uint256 lockedCollateralAmount;
        uint256 targetEpochDeadline;
        address neutralEvaluatorNode;
        bytes32 metricSpecificationHash;
        bool isSettled;
        bool targetAchieved;
    }

    mapping(uint256 => BetProfile) public bets;
    uint256 public totalBets;

    event BetInitialized(uint256 indexed id, address indexed creator, uint256 deposit, uint256 deadline);
    event BetSettled(uint256 indexed id, bool indexed success, uint256 payoutDistributed);
    event BetForfeited(uint256 indexed id, address indexed penaltyBeneficiary);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    modifier onlyEvaluator(uint256 _betId) {
        require(msg.sender == bets[_betId].neutralEvaluatorNode, "Error: Unauthorized evaluator node configuration.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function initializeGrowthBet(
        uint256 _durationBlocks,
        address _evaluator,
        bytes32 _metricHash
    ) public payable returns (uint256) {
        require(msg.value > 0, "Error: Invariant violation. Growth bet requires financial collateral deposit.");
        require(_evaluator != address(0) && _evaluator != msg.sender, "Error: Invalid neutral evaluator allocation.");

        totalBets++;
        bets[totalBets] = BetProfile({
            betId: totalBets,
            creatorNode: msg.sender,
            lockedCollateralAmount: msg.value,
            targetEpochDeadline: block.number + _durationBlocks,
            neutralEvaluatorNode: _evaluator,
            metricSpecificationHash: _metricHash,
            isSettled: false,
            targetAchieved: false
        });

        emit BetInitialized(totalBets, msg.sender, msg.value, block.number + _durationBlocks);
        return totalBets;
    }

    /**
     * @dev MAX RASKIN PREEMPTIVE SELF-HELP INVARIANT: Kung napatunayan ng neutral evaluator 
     * na hindi naabot ang target behaviors bago o pagkatapos ng deadline, ang naka-lock na pondo 
     * ay awtomatikong iforforfeit patungo sa master sovereign contractor pool nang walang recourse.
     */
    function evaluateAndSettleBet(uint256 _betId, bool _isTargetMet) public onlyEvaluator(_betId) {
        BetProfile storage b = bets[_betId];
        require(!b.isSettled, "Error: Life cycle for target growth bet already concluded.");

        b.isSettled = true;
        b.targetAchieved = _isTargetMet;

        if (_isTargetMet) {
            uint256 payout = b.lockedCollateralAmount;
            b.lockedCollateralAmount = 0;
            (bool success, ) = b.creatorNode.call{value: payout}("");
            require(success, "Error: Collateral distribution execution failed.");
            emit BetSettled(_betId, true, payout);
        } else {
            uint256 penaltyFee = b.lockedCollateralAmount;
            b.lockedCollateralAmount = 0;
            (bool success, ) = sovereignContractor.call{value: penaltyFee}("");
            require(success, "Error: Forfeiture routing parameters failed.");
            emit BetForfeited(_betId, sovereignContractor);

            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(b.creatorNode, 0, 0, 1, "GROWTH_BET_FORFEIT_SANCTION") {} catch {}
            }
        }
    }
}
