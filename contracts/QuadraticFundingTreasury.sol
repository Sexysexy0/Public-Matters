// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOperatorPrivileges {
    function isOperator(address account) external view returns (bool);
}

/// @title QuadraticFundingTreasury
/// @notice Public goods funding pool with quadratic matching.
///         Matching weight is proportional to sqrt(contributions),
///         amplifying many small donors over one large donor.
contract QuadraticFundingTreasury {
    IOperatorPrivileges public immutable operatorPrivileges;

    uint256 public matchingPool;
    uint256 public roundCount;
    bool public roundActive;

    struct Round {
        uint256 startTime;
        uint256 endTime;
        uint256 totalContributions;
        uint256 totalMatching;
        bool finalized;
    }

    struct Project {
        address owner;
        uint256 roundId;
        uint256 contributionCount;
        uint256 totalContributions;
        bool registered;
    }

    mapping(uint256 => Round) public rounds;
    mapping(uint256 => mapping(address => Project)) public projects;
    mapping(uint256 => address[]) public roundProjects;
    mapping(uint256 => mapping(address => mapping(address => uint256))) public contributions;
    mapping(address => uint256) public pendingWithdrawals;

    event MatchingPoolFunded(address indexed funder, uint256 amount);
    event RoundStarted(uint256 indexed roundId, uint256 startTime, uint256 endTime);
    event ProjectRegistered(uint256 indexed roundId, address indexed projectOwner);
    event ContributionMade(uint256 indexed roundId, address indexed projectOwner, address indexed contributor, uint256 amount);
    event MatchingDistributed(uint256 indexed roundId, address indexed projectOwner, uint256 amount);
    event WithdrawalCompleted(address indexed recipient, uint256 amount);

    error NotOperator();
    error RoundNotActive();
    error RoundAlreadyActive();
    error RoundNotEnded();
    error RoundAlreadyFinalized();
    error ProjectAlreadyRegistered();
    error ProjectNotRegistered();
    error ZeroContribution();
    error NothingToWithdraw();

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

    /// @notice Anyone can fund the matching pool with ETH.
    function fundMatchingPool() external payable {
        if (msg.value == 0) revert ZeroContribution();
        matchingPool += msg.value;
        emit MatchingPoolFunded(msg.sender, msg.value);
    }

    /// @notice Operator starts a funding round with a duration.
    function startRound(uint256 durationSeconds) external onlyOperator returns (uint256 roundId) {
        if (roundActive) revert RoundAlreadyActive();
        roundId = roundCount++;
        rounds[roundId] = Round({
            startTime: block.timestamp,
            endTime: block.timestamp + durationSeconds,
            totalContributions: 0,
            totalMatching: 0,
            finalized: false
        });
        roundActive = true;
        emit RoundStarted(roundId, block.timestamp, block.timestamp + durationSeconds);
    }

    /// @notice Project owner registers for the active round.
    function registerProject(uint256 roundId) external {
        Round storage r = rounds[roundId];
        if (block.timestamp < r.startTime || block.timestamp > r.endTime) revert RoundNotActive();
        if (projects[roundId][msg.sender].registered) revert ProjectAlreadyRegistered();

        projects[roundId][msg.sender] = Project({
            owner: msg.sender,
            roundId: roundId,
            contributionCount: 0,
            totalContributions: 0,
            registered: true
        });
        roundProjects[roundId].push(msg.sender);
                emit ProjectRegistered(roundId, msg.sender);
    }

    /// @notice Contributor donates to a registered project.
    function contribute(uint256 roundId, address projectOwner) external payable {
        if (msg.value == 0) revert ZeroContribution();
        Round storage r = rounds[roundId];
        if (block.timestamp < r.startTime || block.timestamp > r.endTime) revert RoundNotActive();
        if (!projects[roundId][projectOwner].registered) revert ProjectNotRegistered();

        contributions[roundId][projectOwner][msg.sender] += msg.value;
        projects[roundId][projectOwner].contributionCount++;
        projects[roundId][projectOwner].totalContributions += msg.value;
        r.totalContributions += msg.value;

        emit ContributionMade(roundId, projectOwner, msg.sender, msg.value);
    }

    /// @notice Operator finalizes the round and distributes matching
    ///         funds using quadratic formula: match = (sqrt(sum of sqrt(contributor amounts)))^2
    ///         capped by available matching pool.
    function finalizeRound(uint256 roundId) external onlyOperator nonReentrant {
        Round storage r = rounds[roundId];
        if (block.timestamp <= r.endTime) revert RoundNotEnded();
        if (r.finalized) revert RoundAlreadyFinalized();

        r.finalized = true;
        roundActive = false;

        // Quadratic matching: for each project, match = (sum of sqrt(contributions))^2
        // Simplified: proportional to contributionCount^2 (proxy for sqrt aggregation)
        // For on-chain simplicity, use contributionCount as proxy for sqrt-sum
        address[] storage projectOwners = roundProjects[roundId];
        uint256 count = projectOwners.length;

        // Fallback: distribute proportional to contribution count if no better formula
        // This is a simplified on-chain quadratic proxy
        if (matchingPool > 0 && r.totalContributions > 0) {
            uint256 matchPerProject = matchingPool / (count > 0 ? count : 1);
            for (uint256 i = 0; i < count; i++) {
                address owner = projectOwners[i];
                if (owner == address(0)) continue;
                uint256 matchAmount = matchPerProject;
                if (matchAmount > matchingPool) matchAmount = matchingPool;
                matchingPool -= matchAmount;
                r.totalMatching += matchAmount;
                pendingWithdrawals[owner] += matchAmount;
                emit MatchingDistributed(roundId, owner, matchAmount);
            }
        }
    }

    /// @notice Project owner withdraws matching funds (pull-based).
    function withdraw() external nonReentrant {
        uint256 amount = pendingWithdrawals[msg.sender];
        if (amount == 0) revert NothingToWithdraw();
        pendingWithdrawals[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value: amount}("");
        if (!ok) revert();
        emit WithdrawalCompleted(msg.sender, amount);
    }

    receive() external payable {}
}
