// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV13
 * @notice Adds delivery confirmation and automatic refund/reallocation of unclaimed relief.
 */
contract AutoPenaltyEscrowV13 {
    address public steward;

    enum ReliefType { Cash, Goods, Mixed }
    enum DeliveryStatus { Pending, Delivered, Confirmed, Failed }

    struct Household {
        bool verified;
    }

    struct Delivery {
        address household;
        uint256 amountOrValue;
        ReliefType reliefType;
        DeliveryStatus status;
        uint256 deadline; // confirmation cutoff
    }

    struct Proposal {
        uint256 totalAmount;
        address finalSupplier;
        ReliefType finalType;
        bool executionStarted;
        mapping(address => Delivery) deliveries;
        address[] deliveryList;
    }

    mapping(address => Household) public households;
    mapping(uint256 => Proposal) public proposals;
    address public communityTreasury;
    uint256 public proposalCount;

    event HouseholdRegistered(address wallet);
    event ProposalCreated(uint256 proposalId, uint256 totalAmount, ReliefType finalType, address supplier);
    event DeliveryLogged(uint256 proposalId, address household, uint256 value, ReliefType rtype, uint256 deadline);
    event DeliveryConfirmed(uint256 proposalId, address household);
    event DeliveryFailed(uint256 proposalId, address household);
    event UnclaimedReallocated(uint256 proposalId, uint256 amount, address destination);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyHousehold() { require(households[msg.sender].verified, "Not household"); _; }

    constructor(address _treasury) {
        steward = msg.sender;
        communityTreasury = _treasury;
    }

    function registerHousehold(address wallet) external onlySteward {
        households[wallet] = Household(true);
        emit HouseholdRegistered(wallet);
    }

    function createProposal(uint256 totalAmount, ReliefType finalType, address supplier) external onlySteward {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.totalAmount = totalAmount;
        p.finalSupplier = supplier;
        p.finalType = finalType;
        emit ProposalCreated(proposalCount, totalAmount, finalType, supplier);
    }

    // Steward logs each intended delivery
    function logDelivery(uint256 proposalId, address household, uint256 value, uint256 deadline) external onlySteward {
        Proposal storage p = proposals[proposalId];
        p.deliveries[household] = Delivery(household, value, p.finalType, DeliveryStatus.Delivered, deadline);
        p.deliveryList.push(household);
        emit DeliveryLogged(proposalId, household, value, p.finalType, deadline);
    }

    // Household confirms receipt
    function confirmDelivery(uint256 proposalId) external onlyHousehold {
        Delivery storage d = proposals[proposalId].deliveries[msg.sender];
        require(d.status == DeliveryStatus.Delivered, "Not deliverable");
        d.status = DeliveryStatus.Confirmed;
        emit DeliveryConfirmed(proposalId, msg.sender);
    }

    // After deadline, steward or anyone can mark as failed
    function markFailed(uint256 proposalId, address household) public {
        Delivery storage d = proposals[proposalId].deliveries[household];
        require(block.timestamp > d.deadline, "Deadline not passed");
        require(d.status == DeliveryStatus.Delivered, "Not pending");
        d.status = DeliveryStatus.Failed;
        emit DeliveryFailed(proposalId, household);
    }

    // Sweep unclaimed to treasury or next priority wallet
    function reallocateUnclaimed(uint256 proposalId, address destination) external onlySteward {
        Proposal storage p = proposals[proposalId];
        uint256 totalUnclaimed;
        for (uint256 i; i < p.deliveryList.length; i++) {
            address hh = p.deliveryList[i];
            Delivery storage d = p.deliveries[hh];
            if (d.status == DeliveryStatus.Failed) {
                totalUnclaimed += d.amountOrValue;
                d.status = DeliveryStatus.Pending; // marked as reallocated
            }
        }
        (bool ok, ) = payable(destination).call{value: totalUnclaimed}("");
        require(ok, "Reallocation failed");
        emit UnclaimedReallocated(proposalId, totalUnclaimed, destination);
    }
}
