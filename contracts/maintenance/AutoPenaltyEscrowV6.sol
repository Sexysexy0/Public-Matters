// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AutoPenaltyEscrowV6
 * @notice Severity-weighted split to community + households,
 *         cycle-based batching for scalable payouts,
 *         Merkle-based household verification,
 *         and Offense Catalog for standardized severity.
 */
contract AutoPenaltyEscrowV6 {
    address public steward;
    address public utilityTreasury;

    uint16 public constant BPS = 10_000;
    enum Severity { Low, Medium, High, Critical }

    struct Company {
        string name;
        address operator;
        bool registered;
        uint256 escrowBalance;
    }

    struct Offense {
        string code;        // e.g., "ENV_SPILL"
        string description; // e.g., "Environmental Spill"
        Severity severity;
        bool exists;
    }

    struct Cycle {
        uint256 totalAmount;
        uint256 toCommunity;
        uint256 toHouseholdsTotal;
        string emotionalAPR;
        string damayClause;
        address sourceCompany;
        string offenseCode;
        Severity severity;
        uint16 householdBps;
        bool executed;
    }

    mapping(address => bool) public regulators;
    mapping(address => Company) public companies;
    mapping(uint8 => uint16) public severityHouseholdBps;
    mapping(bytes32 => bool) public claimed; // For Merkle proofs
    mapping(string => Offense) public offenseCatalog;

    mapping(uint256 => Cycle) public payoutCycles;
    uint256 public cycleCount;

    event CompanyRegistered(address indexed id, address indexed operator, string name);
    event OffenseRegistered(string code, string description, Severity severity);
    event PenaltyLogged(uint256 indexed cycleId, address sourceCompany, string offenseCode, Severity severity, uint256 amount);
    event CycleExecuted(uint256 indexed cycleId, uint256 householdsPaid, uint256 perHousehold);
    event CommunityPaid(uint256 cycleId, uint256 amount);
    event HouseholdClaim(address indexed wallet, uint256 indexed cycleId, uint256 amount);

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

        severityHouseholdBps[uint8(Severity.Low)]      = 5000;
        severityHouseholdBps[uint8(Severity.Medium)]   = 6000;
        severityHouseholdBps[uint8(Severity.High)]     = 7000;
        severityHouseholdBps[uint8(Severity.Critical)] = 8000;
    }

    // --- Admin ---
    function setRegulator(address reg, bool status) external onlySteward {
        regulators[reg] = status;
    }

    function setUtilityTreasury(address newTreasury) external onlySteward {
        utilityTreasury = newTreasury;
    }

    function setSeverityHouseholdBps(Severity s, uint16 bps) external onlySteward {
        severityHouseholdBps[uint8(s)] = bps;
    }

    function registerCompany(address id, address op, string calldata name) external onlySteward {
        companies[id] = Company(name, op, true, 0);
        emit CompanyRegistered(id, op, name);
    }

    function registerOffense(string calldata code, string calldata description, Severity severity) external onlySteward {
        offenseCatalog[code] = Offense(code, description, severity, true);
        emit OffenseRegistered(code, description, severity);
    }

    // --- Core ---
    function logPenalty(
        address companyId,
        string calldata offenseCode,
        string calldata emotionalAPR,
        string calldata damayClause
    ) external payable onlyRegulator {
        require(offenseCatalog[offenseCode].exists, "Offense not found");
        Company storage c = companies[companyId];
        require(c.registered, "Company not registered");
        require(msg.value > 0, "No penalty amount");

        Offense memory off = offenseCatalog[offenseCode];
        uint16 hhBps = severityHouseholdBps[uint8(off.severity)];
        uint256 toHouseholds = (msg.value * hhBps) / BPS;
        uint256 toCommunity = msg.value - toHouseholds;

        // New cycle created
        cycleCount++;
        payoutCycles[cycleCount] = Cycle({
            totalAmount: msg.value,
            toCommunity: toCommunity,
            toHouseholdsTotal: toHouseholds,
            emotionalAPR: emotionalAPR,
            damayClause: damayClause,
            sourceCompany: companyId,
            offenseCode: offenseCode,
            severity: off.severity,
            householdBps: hhBps,
            executed: false
        });

        emit PenaltyLogged(cycleCount, companyId, offenseCode, off.severity, msg.value);
    }

    function executeCycle(uint256 cycleId) external onlySteward {
        Cycle storage cy = payoutCycles[cycleId];
        require(!cy.executed, "Cycle already executed");

        // Community share sent now
        if (cy.toCommunity > 0) {
            (bool okC, ) = payable(utilityTreasury).call{value: cy.toCommunity}("");
            require(okC, "Community transfer failed");
            emit CommunityPaid(cycleId, cy.toCommunity);
        }

        cy.executed = true;
    }

    // --- Claim flow (households claim their share off-chain verified by Merkle proof) ---
    function claim(uint256 cycleId, uint256 amount, bytes32[] calldata proof, bytes32 merkleRoot) external {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        require(_verify(proof, merkleRoot, leaf), "Invalid proof");
        require(!claimed[keccak256(abi.encodePacked(msg.sender, cycleId))], "Already claimed");

        claimed[keccak256(abi.encodePacked(msg.sender, cycleId))] = true;
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "Transfer failed");
        emit HouseholdClaim(msg.sender, cycleId, amount);
    }

    // Simple Merkle proof verification
    function _verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        return computedHash == root;
    }
}
