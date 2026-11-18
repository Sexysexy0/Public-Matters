// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOperatorPrivileges {
    function isOperator(address account) external view returns (bool);
}

/// @title DisasterAidDistributionRegistry
/// @notice Registry for disaster aid distribution with transparent
///         allocation tracking, beneficiary claims, and operator-gated
///         verification. Pull-based claims, no push transfers.
contract DisasterAidDistributionRegistry {
    enum AidStatus { Registered, Verified, Claimed, Cancelled }

    struct AidRecord {
        address beneficiary;
        uint256 amount;
        string description;
        uint256 registeredAt;
        uint256 verifiedAt;
        uint256 claimedAt;
        AidStatus status;
    }

    IOperatorPrivileges public immutable operatorPrivileges;

    uint256 public recordCount;
    uint256 public totalAllocated;
    uint256 public totalClaimed;

    mapping(uint256 => AidRecord) public records;
    mapping(address => uint256) public claimedByBeneficiary;

    event AidRegistered(uint256 indexed recordId, address indexed beneficiary, uint256 amount, string description);
    event AidVerified(uint256 indexed recordId, address indexed verifier);
    event AidClaimed(uint256 indexed recordId, address indexed beneficiary, uint256 amount);
    event AidCancelled(uint256 indexed recordId, address indexed canceller);

    error NotOperator();
    error NotRegistered();
    error AlreadyVerified();
    error AlreadyClaimed();
    error AlreadyCancelled();
    error NotVerified();
    error ZeroAmount();
    error ZeroAddress();
    error NotBeneficiary();

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

    /// @notice Operator registers an aid allocation for a beneficiary.
    function registerAid(address beneficiary, uint256 amount, string calldata description)
        external onlyOperator returns (uint256 recordId)
    {
        if (beneficiary == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();

        recordId = recordCount++;
        records[recordId] = AidRecord({
            beneficiary: beneficiary,
            amount: amount,
            description: description,
            registeredAt: block.timestamp,
            verifiedAt: 0,
            claimedAt: 0,
            status: AidStatus.Registered
        });
        totalAllocated += amount;
        emit AidRegistered(recordId, beneficiary, amount, description);
    }

    /// @notice Operator verifies an aid allocation (enables claim).
    function verifyAid(uint256 recordId) external onlyOperator {
        AidRecord storage r = records[recordId];
        if (r.status != AidStatus.Registered) revert AlreadyVerified();
        r.status = AidStatus.Verified;
        r.verifiedAt = block.timestamp;
        emit AidVerified(recordId, msg.sender);
    }

    /// @notice Beneficiary claims their verified aid (pull-based).
    function claimAid(uint256 recordId) external nonReentrant {
        AidRecord storage r = records[recordId];
        if (r.status != AidStatus.Verified) revert NotVerified();
        if (msg.sender != r.beneficiary) revert NotBeneficiary();

        r.status = AidStatus.Claimed;
        r.claimedAt = block.timestamp;
        totalClaimed += r.amount;
        claimedByBeneficiary[msg.sender] += r.amount;
        (bool ok, ) = msg.sender.call{value: r.amount}("");
        if (!ok) revert();
        emit AidClaimed(recordId, msg.sender, r.amount);
    }

    /// @notice Operator cancels an unclaimed aid allocation.
    function cancelAid(uint256 recordId) external onlyOperator {
        AidRecord storage r = records[recordId];
        if (r.status == AidStatus.Claimed) revert AlreadyClaimed();
        if (r.status == AidStatus.Cancelled) revert AlreadyCancelled();
        r.status = AidStatus.Cancelled;
        totalAllocated -= r.amount;
        emit AidCancelled(recordId, msg.sender);
    }

    receive() external payable {}
}
