// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FiscalDisciplineCodex
/// @notice Covenant contract to enforce strict budget compliance, monitor spending velocity, and safeguard resource allocation integrity
contract FiscalDisciplineCodex {
    event AllocationApproved(bytes32 indexed allocationId, address indexed targetNode, uint256 amount, bytes32 authorizationHash);
    event SpendingVelocityExceeded(bytes32 indexed allocationId, uint256 observedVelocity, uint256 thresholdLimit);
    event FiscalConsolidationEnforced(bytes32 indexed constraintHash, string strategicReason, bool strictModeActive);
    event FiscalAuthorityTransferred(address indexed oldSteward, address indexed newSteward);

    address public fiscalSteward;
    bool public strictFiscalControls;

    uint256 public totalReservedFunds;
    uint256 public globalSpendingVelocityLimit; // Maximum allowable resource movement window per cycle
    uint256 public lastConsolidationBlock;

    struct FiscalProfile {
        bool isAuthorized;
        uint256 allocatedCap;
        uint256 currentSpent;
        uint256 lastTransactionTimestamp;
    }

    // Mapping from unique allocation entity hash to its structural financial parameters
    mapping(bytes32 => FiscalProfile) public fiscalRegistry;

    constructor(uint256 _globalVelocityLimit) {
        fiscalSteward = msg.sender;
        globalSpendingVelocityLimit = _globalVelocityLimit;
        strictFiscalControls = true;
        lastConsolidationBlock = block.number;
    }

    modifier onlySteward() {
        require(msg.sender == fiscalSteward, "Unauthorized: Fiscal Steward clearance token verification failed");
        _;
    }

    /// @notice Initialize a verified structural asset allocation block under strict fiscal monitoring
    /// @param _allocationId Unique cryptographic identity hash assigned to the specific project budget
    /// @param _targetNode The executing node or department wallet address
    /// @param _cap Total allowable asset allocation ceiling for the instance scope
    /// @param _authHash Cryptographic commitment anchor of the official strategic budget documentation
    function registerFiscalAllocation(
        bytes32 _allocationId,
        address _targetNode,
        uint256 _cap,
        bytes32 _authHash
    ) external onlySteward {
        require(_allocationId != bytes32(0), "Invalid allocation identifier");
        require(_targetNode != address(0), "Invalid execution node coordinates");
        require(!fiscalRegistry[_allocationId].isAuthorized, "Fiscal profile already active in registry");

        fiscalRegistry[_allocationId] = FiscalProfile({
            isAuthorized: true,
            allocatedCap: _cap,
            currentSpent: 0,
            lastTransactionTimestamp: block.timestamp
        });

        totalReservedFunds += _cap;
        emit AllocationApproved(_allocationId, _targetNode, _cap, _authHash);
    }

    /// @notice Audit and track asset expenditure velocity inside the active infrastructure loops
    /// @param _allocationId Cryptographic identity string of the analyzed allocation layer
    /// @param _withdrawAmount The asset volume requested for immediate transaction routing
    function executeSpendValidation(bytes32 _allocationId, uint256 _withdrawAmount) external {
        FiscalProfile storage profile = fiscalRegistry[_allocationId];
        require(profile.isAuthorized, "Target transaction instance profile not active in ledger");
        require(profile.currentSpent + _withdrawAmount <= profile.allocatedCap, "Fiscal Limit: Withdrawal exceeds allocated contract cap");

        // Calculate velocity metrics based on temporal metrics
        uint256 currentVelocity = _withdrawAmount / (block.timestamp - profile.lastTransactionTimestamp + 1);

        if (strictFiscalControls && currentVelocity > globalSpendingVelocityLimit) {
            profile.isAuthorized = false; // Systemic intervention: Freeze allocation layer to prevent budget drainage
            emit SpendingVelocityExceeded(_allocationId, currentVelocity, globalSpendingVelocityLimit);
            return;
        }

        profile.currentSpent += _withdrawAmount;
        profile.lastTransactionTimestamp = block.timestamp;
    }

    /// @notice Calibrate and trigger strict rebalance frameworks to counter market volatility or project deviations
    function enforceFiscalConsolidation(bytes32 _constraintHash, string memory _reason, bool _strictState) external onlySteward {
        strictFiscalControls = _strictState;
        lastConsolidationBlock = block.number;
        emit FiscalConsolidationEnforced(_constraintHash, _reason, _strictState);
    }

    /// @notice Re-calibrate the global spending velocity bounds to align with real production paces
    function adjustGlobalVelocityLimit(uint256 _newVelocityLimit) external onlySteward {
        globalSpendingVelocityLimit = _newVelocityLimit;
    }

    /// @notice Read-only validation verifying fiscal alignment and allocation metrics
    function checkFiscalIntegrity(bytes32 _allocationId) external view returns (bool clear, uint256 remainingCap, uint256 utilizationPercentage) {
        FiscalProfile memory profile = fiscalRegistry[_allocationId];
        if (profile.allocatedCap == 0) {
            return (false, 0, 0);
        }
        uint256 remainder = profile.allocatedCap - profile.currentSpent;
        uint256 utilization = (profile.currentSpent * 100) / profile.allocatedCap;
        return (profile.isAuthorized, remainder, utilization);
    }

    /// @notice Upgrade or migrate the central Fiscal Steward validation structure
    function transferFiscalAuthority(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Invalid upgrade destination coordinates");
        emit FiscalAuthorityTransferred(fiscalSteward, _newSteward);
        fiscalSteward = _newSteward;
    }
}
