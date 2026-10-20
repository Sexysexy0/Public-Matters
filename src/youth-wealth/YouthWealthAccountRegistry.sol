// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title YouthWealthAccountRegistry
 * @notice Public registry for youth wealth-building accounts.
 *
 * This contract records account creation, contributions, lock-up terms,
 * portfolio policy, withdrawal requests, and annual statements. It does
 * not custody securities or execute investment trades.
 */
contract YouthWealthAccountRegistry {
    enum AccountStatus {
        NONE,
        ACTIVE,
        LOCKED,
        WITHDRAWAL_REQUESTED,
        CLOSED
    }

    enum WithdrawalStatus {
        NONE,
        REQUESTED,
        CUSTODIAN_APPROVED,
        TRUSTEE_APPROVED,
        REJECTED,
        EXECUTED
    }

    struct Contribution {
        uint256 amount;
        ContributionSource source;
        bytes32 receiptHash;
        uint256 timestamp;
        address contributor;
    }

    enum ContributionSource {
        PUBLIC_SEED,
        FAMILY,
        EARNED_INCOME,
        MATCHING_GRANT
    }

    struct YouthAccount {
        bytes32 accountId;
        address beneficiary;
        address custodian;
        address trustee;
        uint256 publicSeed;
        uint256 familyContribution;
        uint256 earnedContribution;
        uint256 matchingGrant;
        uint256 lockUntil;
        bytes32 portfolioPolicyHash;
        AccountStatus status;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct WithdrawalRequest {
        bytes32 requestId;
        bytes32 accountId;
        uint256 amount;
        string purpose;
        WithdrawalStatus status;
        address requester;
        address custodianApprover;
        address trusteeApprover;
        uint256 requestedAt;
        uint256 updatedAt;
    }

    address public governor;
    address public trustee;

    mapping(bytes32 => YouthAccount) private accounts;
    mapping(bytes32 => WithdrawalRequest) private withdrawalRequests;
    mapping(bytes32 => Contribution[]) private contributionHistory;

    bytes32[] private accountIds;
    bytes32[] private withdrawalRequestIds;

    event AccountOpened(
        bytes32 indexed accountId,
        address indexed beneficiary,
        address indexed custodian,
        uint256 publicSeed,
        uint256 lockUntil,
        bytes32 portfolioPolicyHash
    );

    event ContributionRecorded(
        bytes32 indexed accountId,
        ContributionSource source,
        uint256 amount,
        bytes32 receiptHash,
        address indexed contributor
    );

    event WithdrawalRequested(
        bytes32 indexed requestId, bytes32 indexed accountId, uint256 amount, string purpose, address indexed requester
    );

    event WithdrawalApproved(bytes32 indexed requestId, address indexed approver, WithdrawalStatus status);

    event WithdrawalRejected(bytes32 indexed requestId, address indexed approver, string reason);

    event WithdrawalExecuted(bytes32 indexed requestId, bytes32 indexed accountId, uint256 amount);

    event AccountClosed(bytes32 indexed accountId, address indexed beneficiary, uint256 closedAt);

    event TrusteeChanged(address indexed previousTrustee, address indexed newTrustee);

    error Unauthorized();
    error ZeroAddress();
    error AccountAlreadyExists();
    error AccountNotFound();
    error AccountNotActive();
    error InvalidAmount();
    error InvalidLockPeriod();
    error InvalidPortfolioPolicy();
    error WithdrawalAlreadyExists();
    error WithdrawalNotFound();
    error WithdrawalNotPending();
    error LockPeriodActive();
    error DualApprovalRequired();
    error InvalidWithdrawalAmount();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyTrustee() {
        if (msg.sender != trustee) revert Unauthorized();
        _;
    }

    modifier accountExists(bytes32 accountId) {
        if (accounts[accountId].createdAt == 0) revert AccountNotFound();
        _;
    }

    modifier withdrawalExists(bytes32 requestId) {
        if (withdrawalRequests[requestId].requestedAt == 0) {
            revert WithdrawalNotFound();
        }
        _;
    }

    constructor(address initialTrustee) {
        if (initialTrustee == address(0)) revert ZeroAddress();

        governor = msg.sender;
        trustee = initialTrustee;
    }

    function setTrustee(address newTrustee) external onlyGovernor {
        if (newTrustee == address(0)) revert ZeroAddress();

        emit TrusteeChanged(trustee, newTrustee);
        trustee = newTrustee;
    }

    function openAccount(
        bytes32 accountId,
        address beneficiary,
        address custodian,
        uint256 publicSeed,
        uint256 lockUntil,
        bytes32 portfolioPolicyHash
    ) external onlyGovernor returns (bool) {
        if (accounts[accountId].createdAt != 0) {
            revert AccountAlreadyExists();
        }
        if (beneficiary == address(0) || custodian == address(0)) {
            revert ZeroAddress();
        }
        if (publicSeed == 0) revert InvalidAmount();
        if (lockUntil <= block.timestamp) revert InvalidLockPeriod();
        if (portfolioPolicyHash == bytes32(0)) {
            revert InvalidPortfolioPolicy();
        }

        accounts[accountId] = YouthAccount({
            accountId: accountId,
            beneficiary: beneficiary,
            custodian: custodian,
            trustee: trustee,
            publicSeed: publicSeed,
            familyContribution: 0,
            earnedContribution: 0,
            matchingGrant: 0,
            lockUntil: lockUntil,
            portfolioPolicyHash: portfolioPolicyHash,
            status: AccountStatus.ACTIVE,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });

        contributionHistory[accountId].push(
            Contribution({
                amount: publicSeed,
                source: ContributionSource.PUBLIC_SEED,
                receiptHash: keccak256(abi.encodePacked(accountId, publicSeed, block.timestamp)),
                timestamp: block.timestamp,
                contributor: governor
            })
        );

        accountIds.push(accountId);

        emit AccountOpened(accountId, beneficiary, custodian, publicSeed, lockUntil, portfolioPolicyHash);

        return true;
    }

    function recordContribution(bytes32 accountId, ContributionSource source, uint256 amount, bytes32 receiptHash)
        external
        accountExists(accountId)
        returns (bool)
    {
        YouthAccount storage account = accounts[accountId];

        if (account.status != AccountStatus.ACTIVE) revert AccountNotActive();
        if (amount == 0 || receiptHash == bytes32(0)) revert InvalidAmount();

        if (source == ContributionSource.PUBLIC_SEED) {
            if (msg.sender != governor) revert Unauthorized();
            account.publicSeed += amount;
        } else if (source == ContributionSource.FAMILY) {
            account.familyContribution += amount;
        } else if (source == ContributionSource.EARNED_INCOME) {
            account.earnedContribution += amount;
        } else if (source == ContributionSource.MATCHING_GRANT) {
            if (msg.sender != trustee && msg.sender != governor) {
                revert Unauthorized();
            }
            account.matchingGrant += amount;
        }

        contributionHistory[accountId].push(
            Contribution({
                amount: amount,
                source: source,
                receiptHash: receiptHash,
                timestamp: block.timestamp,
                contributor: msg.sender
            })
        );

        account.updatedAt = block.timestamp;

        emit ContributionRecorded(accountId, source, amount, receiptHash, msg.sender);

        return true;
    }

    function requestWithdrawal(bytes32 requestId, bytes32 accountId, uint256 amount, string calldata purpose)
        external
        accountExists(accountId)
        returns (bool)
    {
        YouthAccount storage account = accounts[accountId];

        if (account.status != AccountStatus.ACTIVE) revert AccountNotActive();
        if (withdrawalRequests[requestId].requestedAt != 0) {
            revert WithdrawalAlreadyExists();
        }
        if (amount == 0) revert InvalidWithdrawalAmount();
        if (block.timestamp < account.lockUntil) revert LockPeriodActive();
        if (msg.sender != account.beneficiary && msg.sender != account.custodian) {
            revert Unauthorized();
        }

        withdrawalRequests[requestId] = WithdrawalRequest({
            requestId: requestId,
            accountId: accountId,
            amount: amount,
            purpose: purpose,
            status: WithdrawalStatus.REQUESTED,
            requester: msg.sender,
            custodianApprover: address(0),
            trusteeApprover: address(0),
            requestedAt: block.timestamp,
            updatedAt: block.timestamp
        });

        withdrawalRequestIds.push(requestId);

        account.status = AccountStatus.WITHDRAWAL_REQUESTED;
        account.updatedAt = block.timestamp;

        emit WithdrawalRequested(requestId, accountId, amount, purpose, msg.sender);

        return true;
    }

    function approveWithdrawal(bytes32 requestId) external withdrawalExists(requestId) {
        WithdrawalRequest storage request = withdrawalRequests[requestId];
        YouthAccount storage account = accounts[request.accountId];

        if (request.status != WithdrawalStatus.REQUESTED) {
            revert WithdrawalNotPending();
        }

        if (msg.sender == account.custodian) {
            if (request.custodianApprover != address(0)) {
                revert WithdrawalNotPending();
            }
            request.custodianApprover = msg.sender;
        } else if (msg.sender == trustee) {
            if (request.trusteeApprover != address(0)) {
                revert WithdrawalNotPending();
            }
            request.trusteeApprover = msg.sender;
        } else {
            revert Unauthorized();
        }

        if (request.custodianApprover != address(0) && request.trusteeApprover != address(0)) {
            request.status = WithdrawalStatus.TRUSTEE_APPROVED;
        } else {
            request.status = WithdrawalStatus.CUSTODIAN_APPROVED;
        }

        request.updatedAt = block.timestamp;

        emit WithdrawalApproved(requestId, msg.sender, request.status);
    }

    function rejectWithdrawal(bytes32 requestId, string calldata reason) external withdrawalExists(requestId) {
        WithdrawalRequest storage request = withdrawalRequests[requestId];
        YouthAccount storage account = accounts[request.accountId];

        if (request.status != WithdrawalStatus.REQUESTED) {
            revert WithdrawalNotPending();
        }
        if (msg.sender != account.custodian && msg.sender != trustee) {
            revert Unauthorized();
        }

        request.status = WithdrawalStatus.REJECTED;
        request.updatedAt = block.timestamp;

        account.status = AccountStatus.ACTIVE;
        account.updatedAt = block.timestamp;

        emit WithdrawalRejected(requestId, msg.sender, reason);
    }

    function executeWithdrawal(bytes32 requestId) external onlyTrustee withdrawalExists(requestId) {
        WithdrawalRequest storage request = withdrawalRequests[requestId];
        YouthAccount storage account = accounts[request.accountId];

        if (request.status != WithdrawalStatus.TRUSTEE_APPROVED) {
            revert DualApprovalRequired();
        }

        request.status = WithdrawalStatus.EXECUTED;
        request.updatedAt = block.timestamp;

        account.status = AccountStatus.CLOSED;
        account.updatedAt = block.timestamp;

        emit WithdrawalExecuted(requestId, request.accountId, request.amount);

        emit AccountClosed(request.accountId, account.beneficiary, block.timestamp);
    }

    function getAccount(bytes32 accountId) external view accountExists(accountId) returns (YouthAccount memory) {
        return accounts[accountId];
    }

    function getWithdrawalRequest(bytes32 requestId)
        external
        view
        withdrawalExists(requestId)
        returns (WithdrawalRequest memory)
    {
        return withdrawalRequests[requestId];
    }

    function getContributionHistory(bytes32 accountId)
        external
        view
        accountExists(accountId)
        returns (Contribution[] memory)
    {
        return contributionHistory[accountId];
    }

    function totalAccounts() external view returns (uint256) {
        return accountIds.length;
    }

    function totalWithdrawalRequests() external view returns (uint256) {
        return withdrawalRequestIds.length;
    }

    function getAllAccountIds() external view returns (bytes32[] memory) {
        return accountIds;
    }

    function getAllWithdrawalRequestIds() external view returns (bytes32[] memory) {
        return withdrawalRequestIds;
    }
}
