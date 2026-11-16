// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOperatorPrivileges {
    function isOperator(address account) external view returns (bool);
}

/// @title PublicProjectMilestoneEscrow
/// @notice Escrow for public infrastructure projects with phase-based
///         fund release. Funds are released only after operator
///         verification of each milestone's proof-of-completion.
contract PublicProjectMilestoneEscrow {
    enum Status { Active, Completed, Cancelled }

    struct Milestone {
        string description;
        uint256 amount;          // wei allocated to this milestone
        bytes32 proofHash;       // keccak256 of off-chain proof doc
        bool verified;
        bool released;
    }

    struct Project {
        address donor;
        uint256 totalFunded;
        uint256 totalReleased;
        uint256 milestoneCount;
        Status status;
    }

    IOperatorPrivileges public immutable operatorPrivileges;

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;
    mapping(uint256 => mapping(uint256 => Milestone)) public milestones;
    mapping(address => uint256) public pendingWithdrawals;

    event ProjectCreated(uint256 indexed projectId, address indexed donor, uint256 amount);
    event MilestoneAdded(uint256 indexed projectId, uint256 indexed milestoneId, string description, uint256 amount);
    event ProofSubmitted(uint256 indexed projectId, uint256 indexed milestoneId, bytes32 proofHash);
    event MilestoneVerified(uint256 indexed projectId, uint256 indexed milestoneId, uint256 amountReleased);
    event RefundCredited(address indexed donor, uint256 amount);
    event ProjectCancelled(uint256 indexed projectId);

    error NotOperator();
    error NotDonor();
    error ProjectNotActive();
    error InvalidMilestone();
    error AlreadyVerified();
    error AlreadyReleased();
    error NothingToWithdraw();
    error InsufficientBalance();

    modifier onlyOperator() {
        if (!operatorPrivileges.isOperator(msg.sender)) revert NotOperator();
        _;
    }

    bool private locked;
    modifier nonReentrant() {
        if (locked) revert();
        locked = true;
        _;
        locked = false;
    }

    constructor(address _operatorPrivileges) {
        operatorPrivileges = IOperatorPrivileges(_operatorPrivileges);
    }

    /// @notice Donor funds a new project escrow with ETH.
    function createProject() external payable nonReentrant returns (uint256 projectId) {
        if (msg.value == 0) revert InsufficientBalance();
        projectId = projectCount++;
        projects[projectId] = Project({
            donor: msg.sender,
            totalFunded: msg.value,
            totalReleased: 0,
            milestoneCount: 0,
            status: Status.Active
        });
        emit ProjectCreated(projectId, msg.sender, msg.value);
    }

    /// @notice Operator adds a milestone with allocated amount.
    function addMilestone(uint256 projectId, string calldata description, uint256 amount)
        external onlyOperator
    {
        Project storage p = projects[projectId];
        if (p.status != Status.Active) revert ProjectNotActive();
        if (p.totalReleased + amount > p.totalFunded) revert InsufficientBalance();

        uint256 mid = p.milestoneCount++;
        milestones[projectId][mid] = Milestone({
            description: description,
            amount: amount,
            proofHash: bytes32(0),
            verified: false,
            released: false
        });
        emit MilestoneAdded(projectId, mid, description, amount);
    }

    /// @notice Operator submits proof-of-completion hash for a milestone.
    function submitProof(uint256 projectId, uint256 milestoneId, bytes32 proofHash)
        external onlyOperator
    {
        Milestone storage m = milestones[projectId][milestoneId];
        if (m.amount == 0) revert InvalidMilestone();
        if (m.verified) revert AlreadyVerified();
        m.proofHash = proofHash;
        emit ProofSubmitted(projectId, milestoneId, proofHash);
    }

    /// @notice Operator verifies proof and credits the milestone amount
    ///         to the donor's pending withdrawal (pull-based, CEI-safe).
    function verifyAndRelease(uint256 projectId, uint256 milestoneId)
        external onlyOperator nonReentrant
    {
        Project storage p = projects[projectId];
        Milestone storage m = milestones[projectId][milestoneId];
        if (p.status != Status.Active) revert ProjectNotActive();
        if (m.amount == 0) revert InvalidMilestone();
        if (m.verified) revert AlreadyVerified();
        if (m.released) revert AlreadyReleased();
        if (m.proofHash == bytes32(0)) revert InvalidMilestone();

        m.verified = true;
        m.released = true;
        p.totalReleased += m.amount;
        pendingWithdrawals[p.donor] += m.amount;

        emit MilestoneVerified(projectId, milestoneId, m.amount);

        if (p.totalReleased == p.totalFunded) {
            p.status = Status.Completed;
        }
    }

    /// @notice Donor withdraws released milestone funds (pull-based).
    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        if (amount == 0) revert NothingToWithdraw();
        pendingWithdrawals[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: amount}("");
        if (!ok) revert();
        emit RefundCredited(msg.sender, amount);
    }

    /// @notice Operator cancels an active project; remaining funds
    ///         are credited back to donor for withdrawal.
    function cancelProject(uint256 projectId) external onlyOperator nonReentrant {
        Project storage p = projects[projectId];
        if (p.status != Status.Active) revert ProjectNotActive();
        uint256 remaining = p.totalFunded - p.totalReleased;
        p.status = Status.Cancelled;
        if (remaining > 0) {
            pendingWithdrawals[p.donor] += remaining;
        }
        emit ProjectCancelled(projectId);
    }

    receive() external payable {}
}
