// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AIAccountIntegrityRegistry
 * @notice Registry for account-type disclosure, responsible-operator
 *         attribution, and enforcement against deceptive non-human
 *         accounts.
 *
 * This contract records integrity decisions. It does not directly remove
 * accounts from external platforms.
 */
contract AIAccountIntegrityRegistry {
    enum AccountType {
        UNKNOWN,
        HUMAN_OWNER,
        HUMAN_OPERATED_ORGANIZATION,
        AI_ASSISTANT,
        AI_PERSONA,
        AUTOMATED_UTILITY
    }

    enum AccountStatus {
        UNVERIFIED,
        VERIFIED,
        FLAGGED,
        SUSPENDED,
        REMOVED,
        APPEALED,
        RESTORED
    }

    struct Account {
        bytes32 accountId;
        AccountType accountType;
        AccountStatus status;
        address responsibleOperator;
        bytes32 disclosureHash;
        bytes32 identityProofHash;
        bool commercialIntent;
        bool usesRealPersonLikeness;
        bool likenessConsentVerified;
        uint256 registeredAt;
        uint256 updatedAt;
        string notes;
    }

    address public governor;
    address public integrityBoard;

    mapping(bytes32 => Account) private accounts;
    bytes32[] private accountIds;

    event AccountRegistered(
        bytes32 indexed accountId,
        AccountType accountType,
        address indexed responsibleOperator,
        bool commercialIntent,
        bool usesRealPersonLikeness
    );

    event AccountStatusChanged(
        bytes32 indexed accountId,
        AccountStatus oldStatus,
        AccountStatus newStatus,
        address indexed reviewer,
        string notes
    );

    event IntegrityBoardChanged(address indexed previousBoard, address indexed newBoard);

    error Unauthorized();
    error ZeroAddress();
    error AccountAlreadyRegistered();
    error AccountNotFound();
    error InvalidAccountType();
    error MissingDisclosure();
    error MissingOperator();
    error LikenessConsentRequired();
    error InvalidStatusTransition();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyIntegrityBoard() {
        if (msg.sender != integrityBoard && msg.sender != governor) {
            revert Unauthorized();
        }
        _;
    }

    modifier accountExists(bytes32 accountId) {
        if (accounts[accountId].registeredAt == 0) revert AccountNotFound();
        _;
    }

    constructor(address initialIntegrityBoard) {
        if (initialIntegrityBoard == address(0)) revert ZeroAddress();

        governor = msg.sender;
        integrityBoard = initialIntegrityBoard;
    }

    function setIntegrityBoard(address newBoard) external onlyGovernor {
        if (newBoard == address(0)) revert ZeroAddress();

        emit IntegrityBoardChanged(integrityBoard, newBoard);
        integrityBoard = newBoard;
    }

    function registerAccount(
        bytes32 accountId,
        AccountType accountType,
        address responsibleOperator,
        bytes32 disclosureHash,
        bytes32 identityProofHash,
        bool commercialIntent,
        bool usesRealPersonLikeness,
        bool likenessConsentVerified,
        string calldata notes
    ) external onlyGovernor returns (bool) {
        if (accounts[accountId].registeredAt != 0) {
            revert AccountAlreadyRegistered();
        }
        if (accountType == AccountType.UNKNOWN) revert InvalidAccountType();

        if (
            accountType == AccountType.AI_ASSISTANT || accountType == AccountType.AI_PERSONA
                || accountType == AccountType.AUTOMATED_UTILITY
        ) {
            if (responsibleOperator == address(0)) revert MissingOperator();
            if (disclosureHash == bytes32(0)) revert MissingDisclosure();
        }

        if (usesRealPersonLikeness && accountType != AccountType.HUMAN_OWNER && !likenessConsentVerified) {
            revert LikenessConsentRequired();
        }

        accounts[accountId] = Account({
            accountId: accountId,
            accountType: accountType,
            status: AccountStatus.VERIFIED,
            responsibleOperator: responsibleOperator,
            disclosureHash: disclosureHash,
            identityProofHash: identityProofHash,
            commercialIntent: commercialIntent,
            usesRealPersonLikeness: usesRealPersonLikeness,
            likenessConsentVerified: likenessConsentVerified,
            registeredAt: block.timestamp,
            updatedAt: block.timestamp,
            notes: notes
        });

        accountIds.push(accountId);

        emit AccountRegistered(accountId, accountType, responsibleOperator, commercialIntent, usesRealPersonLikeness);

        return true;
    }

    function flagAccount(bytes32 accountId, string calldata notes)
        external
        onlyIntegrityBoard
        accountExists(accountId)
    {
        _changeStatus(accountId, AccountStatus.FLAGGED, notes);
    }

    function suspendAccount(bytes32 accountId, string calldata notes)
        external
        onlyIntegrityBoard
        accountExists(accountId)
    {
        Account storage account = accounts[accountId];

        if (
            account.accountType == AccountType.HUMAN_OWNER
                || account.accountType == AccountType.HUMAN_OPERATED_ORGANIZATION
        ) {
            revert InvalidStatusTransition();
        }

        _changeStatus(accountId, AccountStatus.SUSPENDED, notes);
    }

    function removeDeceptiveAccount(bytes32 accountId, string calldata notes)
        external
        onlyGovernor
        accountExists(accountId)
    {
        Account storage account = accounts[accountId];

        if (
            account.accountType == AccountType.HUMAN_OWNER
                || account.accountType == AccountType.HUMAN_OPERATED_ORGANIZATION
        ) {
            revert InvalidStatusTransition();
        }

        _changeStatus(accountId, AccountStatus.REMOVED, notes);
    }

    function appealAccount(bytes32 accountId, string calldata notes) external accountExists(accountId) {
        Account storage account = accounts[accountId];

        if (
            account.status != AccountStatus.FLAGGED && account.status != AccountStatus.SUSPENDED
                && account.status != AccountStatus.REMOVED
        ) {
            revert InvalidStatusTransition();
        }

        _changeStatus(accountId, AccountStatus.APPEALED, notes);
    }

    function restoreAccount(bytes32 accountId, string calldata notes)
        external
        onlyIntegrityBoard
        accountExists(accountId)
    {
        Account storage account = accounts[accountId];

        if (account.status != AccountStatus.APPEALED) {
            revert InvalidStatusTransition();
        }

        _changeStatus(accountId, AccountStatus.RESTORED, notes);
    }

    function _changeStatus(bytes32 accountId, AccountStatus newStatus, string calldata notes) private {
        Account storage account = accounts[accountId];
        AccountStatus oldStatus = account.status;

        account.status = newStatus;
        account.updatedAt = block.timestamp;
        account.notes = notes;

        emit AccountStatusChanged(accountId, oldStatus, newStatus, msg.sender, notes);
    }

    function getAccount(bytes32 accountId) external view accountExists(accountId) returns (Account memory) {
        return accounts[accountId];
    }

    function totalAccounts() external view returns (uint256) {
        return accountIds.length;
    }

    function getAllAccountIds() external view returns (bytes32[] memory) {
        return accountIds;
    }
}
