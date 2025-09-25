// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CannabisTaxEquityProtocol
/// @notice Registry for overpaid cannabis taxes, refund eligibility, and cooperative grower sovereignty
/// @dev Anchors post-rescheduling refund claims and red tape breach tagging

contract CannabisTaxEquityProtocol {
    // -------- Roles --------
    address public steward;
    mapping(address => bool) public growers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyGrower() {
        require(growers[msg.sender], "Not registered grower");
        _;
    }

    // -------- Types --------
    enum TaxStatus {
        Overpaid,
        EligibleForRefund,
        Refunded,
        Denied
    }

    struct Grower {
        string name;
        string region;
        bool cooperativeMember;
        bool active;
        uint256 registeredAt;
    }

    struct TaxRecord {
        uint256 id;
        address grower;
        uint256 paidAmount;
        uint256 taxYear;
        string jurisdiction;
        TaxStatus status;
        string notes;
        uint256 createdAt;
        uint256 updatedAt;
    }

    // -------- Storage --------
    uint256 public nextTaxId = 1;
    mapping(address => Grower) public growerRegistry;
    mapping(uint256 => TaxRecord) public taxRecords;
    mapping(address => uint256[]) public growerTaxIds;

    // -------- Events --------
    event GrowerRegistered(address indexed grower, string name, string region);
    event TaxRecorded(uint256 indexed taxId, address indexed grower, uint256 amount, string jurisdiction);
    event TaxStatusUpdated(uint256 indexed taxId, TaxStatus status, string notes);
    event RefundIssued(uint256 indexed taxId, address indexed grower, uint256 amount);

    // -------- Constructor --------
    constructor() {
        steward = msg.sender;
    }

    // -------- Grower Management --------
    function registerGrower(address growerAddr, string calldata name, string calldata region, bool cooperativeMember) external onlySteward {
        Grower storage g = growerRegistry[growerAddr];
        require(!g.active, "Already registered");
        g.name = name;
        g.region = region;
        g.cooperativeMember = cooperativeMember;
        g.active = true;
        g.registeredAt = block.timestamp;
        growers[growerAddr] = true;
        emit GrowerRegistered(growerAddr, name, region);
    }

    // -------- Tax Record Management --------
    function recordTaxPayment(
        address growerAddr,
        uint256 amount,
        uint256 taxYear,
        string calldata jurisdiction,
        string calldata notes
    ) external onlySteward returns (uint256 taxId) {
        require(growers[growerAddr], "Grower not registered");
        taxId = nextTaxId++;
        taxRecords[taxId] = TaxRecord({
            id: taxId,
            grower: growerAddr,
            paidAmount: amount,
            taxYear: taxYear,
            jurisdiction: jurisdiction,
            status: TaxStatus.Overpaid,
            notes: notes,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });
        growerTaxIds[growerAddr].push(taxId);
        emit TaxRecorded(taxId, growerAddr, amount, jurisdiction);
    }

    function updateTaxStatus(uint256 taxId, TaxStatus status, string calldata notes) external onlySteward {
        TaxRecord storage tr = taxRecords[taxId];
        require(tr.id != 0, "Tax record not found");
        tr.status = status;
        tr.notes = notes;
        tr.updatedAt = block.timestamp;
        emit TaxStatusUpdated(taxId, status, notes);
        if (status == TaxStatus.Refunded) {
            emit RefundIssued(taxId, tr.grower, tr.paidAmount);
        }
    }

    // -------- Views --------
    function getGrower(address growerAddr) external view returns (Grower memory) {
        return growerRegistry[growerAddr];
    }

    function getTaxRecord(uint256 taxId) external view returns (TaxRecord memory) {
        return taxRecords[taxId];
    }

    function listGrowerTaxRecords(address growerAddr) external view returns (uint256[] memory) {
        return growerTaxIds[growerAddr];
    }
}
