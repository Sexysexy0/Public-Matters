// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PlatformWorkerRelief
/// @notice Covenant contract to manage emergency financial relief distributions, verify worker metrics, and enforce labor protection rules
contract PlatformWorkerRelief {
    event GrantAllocated(bytes32 indexed reliefId, address indexed workerNode, uint256 tokenAmount, string conditionTag);
    event ReliefPackageDisbursed(bytes32 indexed reliefId, address indexed workerNode, uint256 blockTimestamp);
    event WorkerStandingUpdated(address indexed workerNode, bool indexed isActive, uint256 outputScore);
    event ReliefAuthorityTransferred(address indexed oldAuthority, address indexed newAuthority);

    address public reliefAuthority;
    bool public reliefGrantsLocked;
    uint256 public totalDisbursedReliefFunds;

    struct WorkerProfile {
        bool isRegistered;
        bool isActive;
        uint256 totalContributionHours;
        uint256 lastValidationTimestamp;
        uint256 compositePerformanceIndex; // Scaled out of 100
    }

    struct EmergencyGrant {
        uint256 grantAmount;
        bool claimsExecuted;
        bytes32 strategicJustificationHash; // Cryptographic verification link to official impact reports
        uint256 expiryTimestamp;
    }

    // Mapping from worker node coordinate address to structural profiling records
    mapping(address => WorkerProfile) public workerRegistry;
    // Mapping from unique relief batch ID to programmatic grant configurations
    mapping(bytes32 => EmergencyGrant) public reliefGrantsLedger;

    constructor() {
        reliefAuthority = msg.sender;
        reliefGrantsLocked = false;
        totalDisbursedReliefFunds = 0;
    }

    modifier onlyAuthority() {
        require(msg.sender == reliefAuthority, "Unauthorized: Relief Authority credentials check failed");
        _;
    }

    /// @notice Register a verified platform operator, developer, or infrastructure labor node
    function registerWorkerNode(address _worker, uint256 _initialScore) external onlyAuthority {
        require(_worker != address(0), "Invalid worker machine node coordinates");
        require(!workerRegistry[_worker].isRegistered, "Worker profile already enrolled inside layout registry");
        require(_initialScore <= 100, "Performance score validation exception: out of boundary scale");

        workerRegistry[_worker] = WorkerProfile({
            isRegistered: true,
            isActive: true,
            totalContributionHours: 0,
            lastValidationTimestamp: block.timestamp,
            compositePerformanceIndex: _initialScore
        });

        emit WorkerStandingUpdated(_worker, true, _initialScore);
    }

    /// @notice Initialize and stage an emergency financial or resource relief grant pool
    /// @param _reliefId Unique cryptographic tracker token assigned to the relief framework batch
    /// @param _amount Quantitative asset or unit value allocated per qualified node claim
    /// @param _reportCid Cryptographic fingerprint proof document detailing structural dislocation parameters
    /// @param _duration Temporal validity lifetime of the grant track before auto-expiration triggers
    function stageEmergencyGrant(
        bytes32 _reliefId,
        uint256 _amount,
        bytes32 _reportCid,
        uint256 _duration
    ) external onlyAuthority {
        require(_reliefId != bytes32(0), "Invalid configuration identifier token hash");
        require(_amount > 0, "Allocation amount must be greater than zero configuration steps");
        require(reliefGrantsLedger[_reliefId].grantAmount == 0, "Relief package instance already registered in ledger");

        reliefGrantsLedger[_reliefId] = EmergencyGrant({
            grantAmount: _amount,
            claimsExecuted: false,
            strategicJustificationHash: _reportCid,
            expiryTimestamp: block.timestamp + _duration
        });
    }

    /// @notice Execute and disburse an approved emergency relief packet directly to an active worker node
    /// @param _reliefId Cryptographic identity string of the staged relief token batch
    /// @param _workerNode The destination worker address authorized to absorb the stabilization payout
    /// @param _condition Metadata string verifying compliance context (e.g., "Systemic Down-time Compensation")
    function executeReliefPayout(
        bytes32 _reliefId,
        address payable _workerNode,
        string memory _condition
    ) external onlyAuthority {
        require(!reliefGrantsLocked, "Systemic Override: Grant distributions are currently frozen by authority");
        
        EmergencyGrant storage grant = reliefGrantsLedger[_reliefId];
        require(grant.grantAmount > 0, "Target relief blueprint instance does not exist in ledger");
        require(!grant.claimsExecuted, "Execution Collision: Target grant package already executed or depleted");
        require(block.timestamp <= grant.expiryTimestamp, "Temporal Exception: Relief grant validation timeframe has expired");

        WorkerProfile memory worker = workerRegistry[_workerNode];
        require(worker.isRegistered && worker.isActive, "Access Denied: Target node has no valid standing clearance");

        grant.claimsExecuted = true;
        totalDisbursedReliefFunds += grant.grantAmount;

        (bool success, ) = _workerNode.call{value: grant.grantAmount}("");
        require(success, "Critical Fault: Failed to execute economic asset transference to worker node");

        emit GrantAllocated(_reliefId, _workerNode, grant.grantAmount, _condition);
        emit ReliefPackageDisbursed(_reliefId, _workerNode, block.timestamp);
    }

    /// @notice Calibrate worker performance indexes to reflect dynamic structural output adjustments
    function updateWorkerMetrics(address _worker, uint256 _newScore, uint256 _hoursAdded) external onlyAuthority {
        require(workerRegistry[_worker].isRegistered, "Worker configuration profile not found");
        require(_newScore <= 100, "Performance index out of boundary range");

        workerRegistry[_worker].compositePerformanceIndex = _newScore;
        workerRegistry[_worker].totalContributionHours += _hoursAdded;
        workerRegistry[_worker].lastValidationTimestamp = block.timestamp;

        emit WorkerStandingUpdated(_worker, workerRegistry[_worker].isActive, _newScore);
    }

    /// @notice Toggle emergency grant locks instantly to defend core reserves during network attacks
    function toggleGrantsLock(bool _lockStatus) external onlyAuthority {
        reliefGrantsLocked = _lockStatus;
    }

    /// @notice Upgrade or migrate the central Relief Authority execution framework
    function transferReliefAuthority(address _newAuthority) external onlyAuthority {
        require(_newAuthority != address(0), "Invalid upgrade destination coordinates");
        emit ReliefAuthorityTransferred(reliefAuthority, _newAuthority);
        reliefAuthority = _newAuthority;
    }

    receive() external payable {}
}
