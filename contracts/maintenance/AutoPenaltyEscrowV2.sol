// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV2
 * @notice Escrows corporate penalties, auto‑pays community electricity fund,
 *         and logs emotional APR + damay clause tags for transparent civic resonance.
 */
contract AutoPenaltyEscrowV2 {
    address public steward;
    address public utilityTreasury; // barangay/community electric fund

    struct Company {
        string name;
        address operator;
        bool registered;
        uint256 escrowBalance;
    }

    struct PayoutRecord {
        uint256 amount;
        string purpose;
        string emotionalAPR; // e.g., "High Mercy / High Clarity"
        string damayClause;  // e.g., "If we light them, we light ourselves"
    }

    mapping(address => Company) public companies;
    mapping(address => bool) public regulators;
    mapping(uint256 => PayoutRecord) public payoutLedger;

    uint256 public payoutCount;

    event CompanyRegistered(address indexed id, address indexed operator, string name);
    event PenaltyDeposited(address indexed operator, uint256 amount, string reason);
    event CommunityPaid(uint256 amount, string purpose, string emotionalAPR, string damayClause);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRegulator() {
        require(regulators[msg.sender], "Not regulator");
        _;
    }

    constructor(address _utilityTreasury) {
        steward = msg.sender;
        utilityTreasury = _utilityTreasury;
        regulators[msg.sender] = true;
    }

    function setRegulator(address reg, bool status) external onlySteward {
        regulators[reg] = status;
    }

    function registerCompany(address id, address op, string calldata name) external onlySteward {
        companies[id] = Company(name, op, true, 0);
        emit CompanyRegistered(id, op, name);
    }

    function logPenalty(
        address id,
        string calldata reason,
        string calldata emotionalAPR,
        string calldata damayClause
    ) external payable onlyRegulator {
        Company storage c = companies[id];
        require(c.registered, "Not registered");
        require(msg.value > 0, "No penalty amount");
        c.escrowBalance += msg.value;
        emit PenaltyDeposited(c.operator, msg.value, reason);
        _autoPayCommunity(id, emotionalAPR, damayClause);
    }

    function _autoPayCommunity(
        address id,
        string memory emotionalAPR,
        string memory damayClause
    ) internal {
        Company storage c = companies[id];
        uint256 payout = c.escrowBalance;
        c.escrowBalance = 0;
        (bool sent, ) = payable(utilityTreasury).call{value: payout}("");
        require(sent, "Failed to send to community");

        payoutCount++;
        payoutLedger[payoutCount] = PayoutRecord(payout, "Electric utility coverage", emotionalAPR, damayClause);

        emit CommunityPaid(payout, "Electric utility coverage", emotionalAPR, damayClause);
    }
}
