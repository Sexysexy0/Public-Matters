// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConsumerProtectionLedger
/// @notice Covenant contract to safeguard consumer rights, manage automated dispute escrows, and enforce systemic market fairness
contract ConsumerProtectionLedger {
    event DisputeLogged(bytes32 indexed disputeId, address indexed consumer, address indexed merchant, uint256 escrowAmount);
    event DisputeResolved(bytes32 indexed disputeId, address indexed recipient, string resolutionDetails);
    event MerchantFlagged(address indexed merchant, string infractionType, uint256 severity);
    event ProtectionAuthorityUpdated(address indexed previousAuthority, address indexed newAuthority);

    address public protectionAuthority;
    uint256 public constant DISPUTE_LOCK_PERIOD = 14 days;

    struct Dispute {
        address consumer;
        address merchant;
        uint256 escrowAmount;
        bool isResolved;
        bool fundsReleased;
        uint256 loggedTimestamp;
    }

    // Mapping from unique dispute ID to dispute metadata
    mapping(bytes32 => Dispute) public disputeRegistry;
    // Mapping to track merchant standing and trust index (true if flagged as high-risk)
    mapping(address => bool) public highRiskMerchants;

    constructor() {
        protectionAuthority = msg.sender;
    }

    modifier onlyAuthority() {
        require(msg.sender == protectionAuthority, "Unauthorized: Protection Authority clearance required");
        _;
    }

    /// @notice Initialize a secure consumer dispute escrow block
    /// @param _disputeId Cryptographic identifier for the transaction conflict
    /// @param _consumer The address of the consumer filing the complaint
    /// @param _merchant The target merchant or provider address
    function logConsumerDispute(
        bytes32 _disputeId,
        address _consumer,
        address _merchant
    ) external payable {
        require(_disputeId != bytes32(0), "Invalid dispute token");
        require(_consumer != address(0) && _merchant != address(0), "Invalid participant coordinates");
        require(msg.value > 0, "Escrow value must be greater than zero");
        require(disputeRegistry[_disputeId].loggedTimestamp == 0, "Dispute ID already exists in registry");

        disputeRegistry[_disputeId] = Dispute({
            consumer: _consumer,
            merchant: _merchant,
            escrowAmount: msg.value,
            isResolved: false,
            fundsReleased: false,
            loggedTimestamp: block.timestamp
        });

        emit DisputeLogged(_disputeId, _consumer, _merchant, msg.value);
    }

    /// @notice Mathematically resolve and settle locked consumer dispute escrows
    /// @param _disputeId Cryptographic identity of the dispute instance
    /// @param _refundToConsumer True if funds should be returned to consumer; false if released to merchant
    /// @param _details Summary of the governance validation resolution
    function resolveDispute(
        bytes32 _disputeId,
        bool _refundToConsumer,
        string memory _details
    ) external onlyAuthority {
        Dispute storage dispute = disputeRegistry[_disputeId];
        require(dispute.loggedTimestamp > 0, "Target dispute not found in ledger");
        require(!dispute.isResolved, "Target dispute checkpoint already resolved and finalized");
        require(!dispute.fundsReleased, "Funds already moved out of active escrow");

        dispute.isResolved = true;
        dispute.fundsReleased = true;

        address recipient = _refundToConsumer ? dispute.consumer : dispute.merchant;
        uint256 amount = dispute.escrowAmount;

        (bool success, ) = payable(recipient).call{value: amount}("");
        require(success, "Failed to execute escrow asset transfer");

        emit DisputeResolved(_disputeId, recipient, _details);
    }

    /// @notice Flag fraudulent or malicious merchants violating market dignity safeguards
    function flagMerchantViolation(
        address _merchant, 
        string memory _infraction, 
        uint256 _severity
    ) external onlyAuthority {
        require(_merchant != address(0), "Invalid merchant address metrics");
        require(_severity >= 1 && _severity <= 5, "Severity scope must scale from 1 to 5");

        if (_severity >= 4) {
            highRiskMerchants[_merchant] = true;
        }

        emit MerchantFlagged(_merchant, _infraction, _severity);
    }

    /// @notice Read-only validation checking structural consumer dispute parameters
    function checkDisputeStatus(bytes32 _disputeId) external view returns (bool resolved, uint256 assetAmount, uint256 lockedTimeLeft) {
        Dispute memory章 dispute = disputeRegistry[_disputeId];
        uint256 timeLeft = 0;
        if (block.timestamp < dispute.loggedTimestamp + DISPUTE_LOCK_PERIOD) {
            timeLeft = (dispute.loggedTimestamp + DISPUTE_LOCK_PERIOD) - block.timestamp;
        }
        return (dispute.isResolved, dispute.escrowAmount, timeLeft);
    }

    /// @notice Upgrade or migrate the Protection Authority layer
    function transferProtectionAuthority(address _newAuthority) external onlyAuthority {
        require(_newAuthority != address(0), "Invalid authority coordinates");
        protectionAuthority = _newAuthority;
        emit ProtectionAuthorityUpdated(msg.sender, _newAuthority);
    }
}
