// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ReliefGoodsSubstitutionAct
 * @notice Switches misusing beneficiaries from cash to in-kind (grocery/relief) vouchers,
 *         supports round-based recertification, and grants housing support for cohabiting families.
 */
contract ReliefGoodsSubstitutionAct {
    address public steward;

    struct Beneficiary {
        string name;
        address wallet;
        bool registered;
        bool cashActive;     // eligible for cash payouts
        bool inKindActive;   // eligible for voucher payouts
        uint8 strikes;       // misuse strikes (policy-defined)
        bool cohabiting;     // living with parents/relatives (for housing pathway)
        bool housingEligible;
        uint256 voucherBalance; // in wei; pegged stablecoin or native for demo
    }

    struct Recert {
        bool exists;
        bool submitted;
        bool approved;
        bool cohabiting;     // updated declaration
        string notes;        // context (employment change, dependents, etc.)
        bool cashAllowed;    // auditor decision
        bool inKindOnly;     // auditor decision
        bool housingEligible;// auditor decision
    }

    struct HousingGrant {
        uint256 amount;
        address payTo;       // landlord/developer/escrow
        bool active;
        bool disbursed;
    }

    mapping(address => Beneficiary) public beneficiaries;
    mapping(address => bool) public auditors;
    mapping(address => bool) public suppliers; // whitelisted grocery/relief partners
    mapping(uint256 => mapping(address => Recert)) public recerts; // roundId => wallet => recert
    mapping(address => HousingGrant) public housingGrants;

    uint8 public maxCashStrikes = 1;     // after this, force in-kind
    uint256 public cashPayoutAmount = 5000 ether; // represent ₱5k in pegged units
    bool public recertRoundOpen;
    uint256 public currentRoundId;
    uint256 public recertDeadline; // timestamp

    // Events
    event BeneficiaryRegistered(address wallet, string name, bool cashActive, bool inKindActive);
    event CashReleased(address indexed wallet, uint256 amount, uint256 month);
    event MisuseFlag(address indexed wallet, uint8 strikes, string reason);
    event SwitchedToInKind(address indexed wallet);
    event VoucherToppedUp(address indexed wallet, uint256 amount, string purpose);
    event VoucherRedeemed(address indexed wallet, address indexed supplier, uint256 amount, string receiptHash);
    event SupplierSet(address indexed supplier, bool status);
    event AuditorSet(address indexed auditor, bool status);
    event RecertRoundOpened(uint256 roundId, uint256 deadline);
    event RecertSubmitted(uint256 roundId, address wallet, bool cohabiting, string notes);
    event RecertReviewed(uint256 roundId, address wallet, bool cashAllowed, bool inKindOnly, bool housingEligible);
    event HousingGranted(address wallet, uint256 amount, address payTo);
    event HousingDisbursed(address wallet, uint256 amount, address payTo);

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender], "Not auditor");
        _;
    }

    modifier onlySupplier() {
        require(suppliers[msg.sender], "Not supplier");
        _;
    }

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
    }

    // --- Admin & policy ---

    function setAuditor(address who, bool status) external onlySteward {
        auditors[who] = status;
        emit AuditorSet(who, status);
    }

    function setSupplier(address who, bool status) external onlySteward {
        suppliers[who] = status;
        emit SupplierSet(who, status);
    }

    function setPolicy(uint8 _maxCashStrikes, uint256 _cashPayoutAmount) external onlySteward {
        maxCashStrikes = _maxCashStrikes;
        cashPayoutAmount = _cashPayoutAmount;
    }

    // --- Registration ---

    function registerBeneficiary(address wallet, string calldata name, bool cohabiting) external onlySteward {
        beneficiaries[wallet] = Beneficiary({
            name: name,
            wallet: wallet,
            registered: true,
            cashActive: true,
            inKindActive: false,
            strikes: 0,
            cohabiting: cohabiting,
            housingEligible: false,
            voucherBalance: 0
        });
        emit BeneficiaryRegistered(wallet, name, true, false);
    }

    // --- Cash payout (until misuse) ---

    function releaseCash(address wallet, uint256 month) external onlySteward {
        Beneficiary storage b = beneficiaries[wallet];
        require(b.registered && b.cashActive, "Cash not active");
        (bool sent, ) = payable(wallet).call{value: cashPayoutAmount}("");
        require(sent, "Cash transfer failed");
        emit CashReleased(wallet, cashPayoutAmount, month);
    }

    // --- Misuse flag -> switch to in-kind ---

    function flagMisuse(address wallet, string calldata reason) external onlyAuditor {
        Beneficiary storage b = beneficiaries[wallet];
        require(b.registered, "Not registered");
        b.strikes += 1;
        emit MisuseFlag(wallet, b.strikes, reason);

        if (b.strikes >= maxCashStrikes) {
            b.cashActive = false;
            b.inKindActive = true;
            emit SwitchedToInKind(wallet);
        }
    }

    // --- Voucher mechanics ---

    function topUpVoucher(address wallet, uint256 amount, string calldata purpose) external onlySteward {
        Beneficiary storage b = beneficiaries[wallet];
        require(b.registered && b.inKindActive, "In-kind not active");
        b.voucherBalance += amount;
        emit VoucherToppedUp(wallet, amount, purpose);
    }

    // Supplier redeems against a beneficiary's voucher balance
    function redeemVoucher(address wallet, uint256 amount, string calldata receiptHash) external onlySupplier {
        Beneficiary storage b = beneficiaries[wallet];
        require(b.inKindActive, "In-kind not active");
        require(b.voucherBalance >= amount, "Insufficient voucher balance");
        b.voucherBalance -= amount;

        // Pay supplier directly
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "Supplier payment failed");

        emit VoucherRedeemed(wallet, msg.sender, amount, receiptHash);
    }

    // --- Recertification rounds ---

    function openRecertRound(uint256 roundId, uint256 deadlineTs) external onlySteward {
        currentRoundId = roundId;
        recertDeadline = deadlineTs;
        recertRoundOpen = true;
        emit RecertRoundOpened(roundId, deadlineTs);
    }

    function submitRecert(bool cohabiting, string calldata notes) external {
        require(recertRoundOpen && block.timestamp <= recertDeadline, "Recert closed");
        Beneficiary storage b = beneficiaries[msg.sender];
        require(b.registered, "Not registered");

        Recert storage r = recerts[currentRoundId][msg.sender];
        r.exists = true;
        r.submitted = true;
        r.cohabiting = cohabiting;
        r.notes = notes;

        emit RecertSubmitted(currentRoundId, msg.sender, cohabiting, notes);
    }

    function reviewRecert(
        uint256 roundId,
        address wallet,
        bool cashAllowed,
        bool inKindOnly,
        bool markHousingEligible
    ) external onlyAuditor {
        Recert storage r = recerts[roundId][wallet];
        require(r.exists && r.submitted, "No recert");
        r.approved = true;
        r.cashAllowed = cashAllowed;
        r.inKindOnly = inKindOnly;
        r.housingEligible = markHousingEligible;

        // Apply decisions
        Beneficiary storage b = beneficiaries[wallet];
        b.cohabiting = r.cohabiting;
        b.housingEligible = markHousingEligible;

        if (inKindOnly) {
            b.cashActive = false;
            b.inKindActive = true;
        } else if (cashAllowed) {
            b.cashActive = true;
            // inKind can remain true if you want hybrid; or force false to return to cash-only
        }

        emit RecertReviewed(roundId, wallet, cashAllowed, inKindOnly, markHousingEligible);
    }

    function closeRecertRound() external onlySteward {
        recertRoundOpen = false;
    }

    // --- Housing pathway ---

    function grantHousingSupport(address wallet, uint256 amount, address payTo) external onlySteward {
        Beneficiary storage b = beneficiaries[wallet];
        require(b.registered && b.housingEligible, "Not housing-eligible");
        housingGrants[wallet] = HousingGrant({
            amount: amount,
            payTo: payTo,
            active: true,
            disbursed: false
        });
        emit HousingGranted(wallet, amount, payTo);
    }

    function disburseHousingSupport(address wallet) external onlySteward {
        HousingGrant storage hg = housingGrants[wallet];
        require(hg.active && !hg.disbursed, "Grant not active");
        hg.disbursed = true;
        (bool ok, ) = payable(hg.payTo).call{value: hg.amount}("");
        require(ok, "Housing disbursement failed");
        emit HousingDisbursed(wallet, hg.amount, hg.payTo);
    }

    // --- Funding ---

    receive() external payable {}
}
