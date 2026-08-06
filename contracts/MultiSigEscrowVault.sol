// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MultiSigEscrowVault
 * @dev Multi-Signature Institutional Vault with Time-Lock for PPPs and Treaties
 */
contract MultiSigEscrowVault {
    address public immutable owner;
    uint256 public constant EXECUTION_DELAY = 1 days; // 24-hour revoke window
    uint256 public requiredConfirmations;
    uint256 public transactionCount;

    struct Transaction {
        address payable to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmations;
        uint256 creationTime;
        mapping(address => bool) isConfirmed;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(address => bool) public isSigner;
    address[] public signers;

    event SignerAdded(address indexed signer);
    event TransactionSubmitted(uint256 indexed txId, address to, uint256 value);
    event TransactionConfirmed(uint256 indexed txId, address indexed signer);
    event TransactionRevoked(uint256 indexed txId, address indexed signer);
    event TransactionExecuted(uint256 indexed txId);

    modifier onlyOwner() {
        require(msg.sender == owner, "MultiSigVault: Only the owner");
        _;
    }

    modifier onlySigner() {
        require(isSigner[msg.sender], "MultiSigVault: Not a signer");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactionCount, "MultiSigVault: Tx does not exist");
        _;
    }

    constructor(address[] memory _signers, uint256 _required) {
        require(_signers.length >= _required, "MultiSigVault: Invalid signer count");
        owner = msg.sender;
        requiredConfirmations = _required;
        for (uint256 i = 0; i < _signers.length; i++) {
            require(_signers[i] != address(0), "MultiSigVault: Invalid signer");
            isSigner[_signers[i]] = true;
            signers.push(_signers[i]);
            emit SignerAdded(_signers[i]);
        }
    }

    receive() external payable {}

    // Submit a payout request to the vault
    function submitTransaction(address payable _to, uint256 _value, bytes calldata _data) external onlySigner returns (uint256) {
        uint256 txId = transactionCount;
        transactions[txId].to = _to;
        transactions[txId].value = _value;
        transactions[txId].data = _data;
        transactions[txId].executed = false;
        transactions[txId].confirmations = 0;
        transactions[txId].creationTime = block.timestamp;
        transactionCount++;
        emit TransactionSubmitted(txId, _to, _value);
    return txId;
    }

    // Approve a transaction
    function confirmTransaction(uint256 _txId) external onlySigner txExists(_txId) {
        Transaction storage transaction = transactions[_txId];
        require(!transaction.isConfirmed[msg.sender], "MultiSigVault: Already confirmed");
        require(!transaction.executed, "MultiSigVault: Already executed");

        transaction.isConfirmed[msg.sender] = true;
        transaction.confirmations++;
        emit TransactionConfirmed(_txId, msg.sender);
    }

    // Revoke your signature (before the 24 hours expire)
    function revokeConfirmation(uint256 _txId) external onlySigner txExists(_txId) {
        Transaction storage transaction = transactions[_txId];
        require(transaction.isConfirmed[msg.sender], "MultiSigVault: Not confirmed");
        require(!transaction.executed, "MultiSigVault: Already executed");

        transaction.isConfirmed[msg.sender] = false;
        transaction.confirmations--;
        emit TransactionRevoked(_txId, msg.sender);
    }

    // Execute the payout if thresholds are met and timelock passed
    function executeTransaction(uint256 _txId) external onlySigner txExists(_txId) {
        Transaction storage transaction = transactions[_txId];
        require(!transaction.executed, "MultiSigVault: Already executed");
        require(transaction.confirmations >= requiredConfirmations, "MultiSigVault: Not enough approvals");
        require(block.timestamp >= transaction.creationTime + EXECUTION_DELAY, "MultiSigVault: Timelock active");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "MultiSigVault: Execution failed");

        emit TransactionExecuted(_txId);
    }

    // Top up the vault
    function deposit() external payable {
        require(msg.value > 0, "Must deposit something");
    }
}
