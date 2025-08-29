// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV4
 * @notice Escrows corporate penalties, splits funds to community + households,
 *         logs emotional APR + damay clause, and maps exact penalty sources
 *         (company + violation) to each payout for full civic transparency.
 */
contract AutoPenaltyEscrowV4 {
    address public steward;
    address public utilityTreasury;

    struct Company {
        string name;
        address operator;
        bool registered;
        uint256 escrowBalance;
    }

    struct Household {
        bool verified;
        address wallet;
    }

    struct PayoutRecord {
        uint256 amount;
        string purpose;
        string emotionalAPR;
        string damayClause;
        address sourceCompany;
        string violationType;
    }

    mapping(address => Company) public companies;
    mapping(address => bool) public regulators;
    mapping(address => Household) public households;
    mapping(uint256 => PayoutRecord) public payoutLedger;

    uint256 public payoutCount;
    uint256 public householdCount;
    address[] public householdIndex;

    event CompanyRegistered(address indexed id, address indexed operator, string name);
    event HouseholdRegistered(address indexed wallet);
    event PenaltyDeposited(address indexed operator, uint256 amount, string reason);
    event CommunityPaid(uint256 amount, string purpose, string emotionalAPR, string damayClause);
    event HouseholdReward(address indexed wallet, uint256 amount, string purpose, address sourceCompany, string violationType);

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

    function registerHousehold(address wallet) external onlySteward {
        require(!households[wallet].verified, "Already verified");
        households[wallet] = Household(true, wallet);
        householdIndex.push(wallet);
        householdCount++;
        emit HouseholdRegistered(wallet);
    }

    function logPenalty(
        address id,
        string calldata violationType,
        string calldata emotionalAPR,
        string calldata damayClause
    ) external payable onlyRegulator {
        Company storage c = companies[id];
        require(c.registered, "Not registered");
        require(msg.value > 0, "No penalty amount");
        c.escrowBalance += msg.value;
        emit PenaltyDeposited(c.operator, msg.value, violationType);
        _autoPayAll(id, violationType, emotionalAPR, damayClause);
    }

    function _autoPayAll(
        address id,
        string memory violationType,
        string memory emotionalAPR,
        string memory damayClause
    ) internal {
        Company storage c = companies[id];
        uint256 payout = c.escrowBalance;
        c.escrowBalance = 0;

        // 50% sa community utility treasury
        uint256 communityShare = payout / 2;
        (bool sentComm, ) = payable(utilityTreasury).call{value: communityShare}("");
        require(sentComm, "Community fund failed");

        // 50% hati-hati sa households
        uint256 householdShareTotal = payout - communityShare;
        uint256 perHousehold = householdCount > 0 ? householdShareTotal / householdCount : 0;
        for (uint256 i = 0; i < householdIndex.length; i++) {
            if (households[householdIndex[i]].verified && perHousehold > 0) {
                (bool sentHH, ) = payable(householdIndex[i]).call{value: perHousehold}("");
                require(sentHH, "Household transfer failed");
                emit HouseholdReward(householdIndex[i], perHousehold, "Penalty micro‑disbursement", id, violationType);
            }
        }

        payoutCount++;
        payoutLedger[payoutCount] = PayoutRecord(
            payout,
            "Electric utility + household rewards",
            emotionalAPR,
            damayClause,
            id,
            violationType
        );

        emit CommunityPaid(payout, "Electric utility + household rewards", emotionalAPR, damayClause);
    }
}
