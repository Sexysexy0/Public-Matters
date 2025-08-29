// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

import "./ContractBiddingBroadcast.sol";
import "./BidAuditScroll.sol";
import "./LGUContractApproval.sol";
import "./KinderQueenVeto.sol";
import "./ContractSanctumBlessing.sol";
import "./AIPoweredContractorRegistry.sol";

contract ContractTransparencySuite {
    address public steward;

    ContractBiddingBroadcast public bidding;
    BidAuditScroll public audit;
    LGUContractApproval public lguApproval;
    KinderQueenVeto public kinderVeto;
    ContractSanctumBlessing public sanctumBlessing;
    AIPoweredContractorRegistry public aiRegistry;

    constructor(
        address _bidding,
        address _audit,
        address _lguApproval,
        address _kinderVeto,
        address _sanctumBlessing,
        address _aiRegistry
    ) {
        steward = msg.sender;
        bidding = ContractBiddingBroadcast(_bidding);
        audit = BidAuditScroll(_audit);
        lguApproval = LGUContractApproval(_lguApproval);
        kinderVeto = KinderQueenVeto(_kinderVeto);
        sanctumBlessing = ContractSanctumBlessing(_sanctumBlessing);
        aiRegistry = AIPoweredContractorRegistry(_aiRegistry);
    }

    function fullContractRitual(
        uint256 projectId,
        uint256 bidIndex,
        string memory emotionalTag,
        bool damayClauseIncluded,
        bool rogueIntentDetected,
        string memory projectName,
        string memory contractor,
        bool ancestralAligned,
        bool communityApproved
    ) public {
        bidding.broadcastBid(projectId, bidIndex, emotionalTag);
        audit.logBidAudit(contractor, bidding.getProject(projectId).bids[bidIndex].bidAmount, emotionalTag, damayClauseIncluded, rogueIntentDetected);
        sanctumBlessing.grantBlessing(projectName, contractor, emotionalTag, ancestralAligned, communityApproved);
    }
}
