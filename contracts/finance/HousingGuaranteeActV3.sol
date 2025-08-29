// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HousingGuaranteeActV3
 * @notice Build-to-own: construction milestones with proofs; escrow releases funds per approved milestone.
 */
contract HousingGuaranteeActV3 {
    address public steward;
    uint16 public constant BPS = 10_000;

    enum ProjectStatus { Planned, Building, Completed }
    enum MilestoneState { Pending, ProofSubmitted, Approved, Paid }

    struct Unit {
        uint256 id;
        string  location;
        address developer;
        uint256 budget;     // total build budget
        ProjectStatus status;
    }

    struct Milestone {
        string  name;              // e.g., "Foundation", "Roof", "Completion"
        uint16  portionBps;        // share of budget to release at this step
        string  proofHash;         // IPFS/Arweave ref submitted by developer
        MilestoneState state;
        uint256 releasedAmount;    // actual funds released
    }

    struct Escrow {
        uint256 familyBalance;
        uint256 subsidyBalance;
    }

    mapping(address => bool) public developers;
    mapping(address => bool) public auditors;

    uint256 public unitCount;
    mapping(uint256 => Unit) public units;
    mapping(uint256 => Milestone[]) public milestones;     // unitId => milestones
    mapping(uint256 => Escrow) public escrows;             // unitId => balances

    uint16 public subsidyBps = 6000; // default split if families deposit without labels

    event DeveloperSet(address dev, bool status);
    event AuditorSet(address auditor, bool status);
    event UnitPlanned(uint256 unitId, string location, address developer, uint256 budget);
    event MilestoneAdded(uint256 unitId, uint256 index, string name, uint16 portionBps);
    event FamilyDeposited(uint256 unitId, uint256 amount);
    event SubsidyDeposited(uint256 unitId, uint256 amount);
    event ProofSubmitted(uint256 unitId, uint256 index, string hashRef);
    event MilestoneApproved(uint256 unitId, uint256 index);
    event MilestonePaid(uint256 unitId, uint256 index, uint256 amountReleased);
    event ProjectCompleted(uint256 unitId);

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyAuditor() { require(auditors[msg.sender], "Not auditor"); _; }

    constructor() { steward = msg.sender; auditors[msg.sender] = true; }

    // Admin
    function setDeveloper(address d, bool s) external onlySteward { developers[d]=s; emit DeveloperSet(d,s); }
    function setAuditor(address a, bool s) external onlySteward { auditors[a]=s; emit AuditorSet(a,s); }
    function setSubsidyBps(uint16 bps) external onlySteward { require(bps<=BPS,"bps>100%"); subsidyBps=bps; }

    // Plan project
    function planUnit(string calldata location, address developer, uint256 budget) external onlySteward {
        require(developers[developer], "Dev not whitelisted");
        require(budget > 0, "Budget=0");
        unitCount++;
        units[unitCount] = Unit(unitCount, location, developer, budget, ProjectStatus.Planned);
        emit UnitPlanned(unitCount, location, developer, budget);
    }

    function addMilestone(uint256 unitId, string calldata name, uint16 portionBps) external onlySteward {
        require(units[unitId].status == ProjectStatus.Planned || units[unitId].status == ProjectStatus.Building, "Bad status");
        milestones[unitId].push(Milestone(name, portionBps, "", MilestoneState.Pending, 0));
        emit MilestoneAdded(unitId, milestones[unitId].length - 1, name, portionBps);
    }

    // Funding escrow
    function depositFamily(uint256 unitId) external payable {
        escrows[unitId].familyBalance += msg.value;
        emit FamilyDeposited(unitId, msg.value);
    }
    function depositSubsidy(uint256 unitId) external payable onlySteward {
        escrows[unitId].subsidyBalance += msg.value;
        emit SubsidyDeposited(unitId, msg.value);
    }

    // Dev submits proof; auditor approves; then funds are released proportionally
    function submitProof(uint256 unitId, uint256 index, string calldata hashRef) external {
        Unit storage u = units[unitId];
        require(msg.sender == u.developer, "Not developer");
        Milestone storage m = milestones[unitId][index];
        require(m.state == MilestoneState.Pending || m.state == MilestoneState.ProofSubmitted, "Wrong state");
        m.proofHash = hashRef;
        m.state = MilestoneState.ProofSubmitted;
        // Move project to Building status if previously Planned
        if (u.status == ProjectStatus.Planned) u.status = ProjectStatus.Building;
        emit ProofSubmitted(unitId, index, hashRef);
    }

    function approveMilestone(uint256 unitId, uint256 index) external onlyAuditor {
        Milestone storage m = milestones[unitId][index];
        require(m.state == MilestoneState.ProofSubmitted, "No proof");
        m.state = MilestoneState.Approved;
        emit MilestoneApproved(unitId, index);
    }

    function payMilestone(uint256 unitId, uint256 index) external {
        Unit storage u = units[unitId];
        Milestone storage m = milestones[unitId][index];
        require(m.state == MilestoneState.Approved, "Not approved");

        uint256 target = (u.budget * m.portionBps) / BPS;
        uint256 familyShare = (target * (BPS - subsidyBps)) / BPS;
        uint256 subsidyShare = target - familyShare;

        Escrow storage e = escrows[unitId];
        require(e.familyBalance >= familyShare && e.subsidyBalance >= subsidyShare, "Escrow insufficient");

        e.familyBalance -= familyShare;
        e.subsidyBalance -= subsidyShare;

        uint256 releaseAmt = familyShare + subsidyShare;
        (bool ok, ) = payable(u.developer).call{value: releaseAmt}("");
        require(ok, "Release failed");

        m.state = MilestoneState.Paid;
        m.releasedAmount = releaseAmt;
        emit MilestonePaid(unitId, index, releaseAmt);

        // If last milestone paid, mark project complete
        if (index == milestones[unitId].length - 1) {
            u.status = ProjectStatus.Completed;
            emit ProjectCompleted(unitId);
        }
    }

    receive() external payable {}
}
