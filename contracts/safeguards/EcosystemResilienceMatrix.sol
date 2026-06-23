// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EcosystemResilienceMatrix
 * @notice Implements state-driven resiliency parameter tiers to modulate system performance and risk sensitivity during macroeconomic or infrastructure disruptions.
 */
contract EcosystemResilienceMatrix {
    event RiskStateTransitioned(RiskLevel indexed previousState, RiskLevel indexed currentState, uint256 transitionBlock);
    event ThrottlingParameterModified(bytes32 indexed componentKey, uint256 oldValue, uint256 newValue);
    event ControlStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public masterSteward;
    uint256 public lastStateTransitionBlock;
    uint256 public constant MIN_STATE_DURATION_BLOCKS = 20; // Enforces stability by preventing rapid state oscillation

    enum RiskLevel { Normal, Elevated, High, Critical }
    RiskLevel public currentRiskState;

    // Configurable infrastructure matrix thresholds linked to component keys
    mapping(bytes32 => uint256) public componentThrottlingMatrix;

    constructor() {
        masterSteward = msg.sender;
        currentRiskState = RiskLevel.Normal;
        lastStateTransitionBlock = block.number;
    }

    modifier onlySteward() {
        require(msg.sender == masterSteward, "Unauthorized Action: Master steward cryptographic identity token match failed");
        _;
    }

    /**
     * @notice Transitions the global framework resilience profile to counter external systemic disruptions.
     * @param _newState Targeted risk level matching the algorithmic telemetry assessments.
     */
    function transitionRiskState(RiskLevel _newState) external onlySteward {
        require(_newState != currentRiskState, "State Exception: Targeted risk state vector matches active configuration");
        require(block.number >= lastStateTransitionBlock + MIN_STATE_DURATION_BLOCKS, "Temporal Guard: Systemic state transition pacing velocity limit active");

        RiskLevel previousState = currentRiskState;
        currentRiskState = _newState;
        lastStateTransitionBlock = block.number;

        emit RiskStateTransitioned(previousState, _newState, block.number);
    }

    /**
     * @notice Dynamically adjusts component specific variables depending on the overarching operational risk posture.
     */
    function configureThrottlingParameter(bytes32 _componentKey, uint256 _matrixValue) external onlySteward {
        require(_componentKey != bytes32(0), "Parameter Error: Matrix reference component identity token cannot be empty");
        
        uint256 oldValue = componentThrottlingMatrix[_componentKey];
        componentThrottlingMatrix[_componentKey] = _matrixValue;

        emit ThrottlingParameterModified(_componentKey, oldValue, _matrixValue);
    }

    /**
     * @notice Read utility interface allowing external safeguard components to audit system sensitivity prior to execution loops.
     */
    function getCurrentRiskParameters(bytes32 _componentKey) external view returns (RiskLevel activeTier, uint256 systemConstraintValue) {
        return (currentRiskState, componentThrottlingMatrix[_componentKey]);
    }

    /**
     * @notice Shift the central master cryptographic consensus key signature destination coordinator.
     */
    function transferControlSteward(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Identity Error: Target root destination falls outside legal system registry parameters");
        masterSteward = _newSteward;
        emit ControlStewardTransferred(msg.sender, _newSteward);
    }
}
