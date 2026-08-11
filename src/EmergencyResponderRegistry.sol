// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

interface ITrustIntegrator {
    function logPositiveAction(address entity, uint256 actionType) external;
}

/**
 * @title EmergencyResponderRegistry
 * @notice Directly funds and verifies local responders, rescue units, and flood action teams.
 */
contract EmergencyResponderRegistry {
    address public immutable owner;
    ITrustIntegrator public immutable trustIntegrator;

    enum UnitStatus {
        Inactive,
        Active,
        Dispatched,
        OnStandby
    }

    struct RescueUnit {
        string teamName;
        address leader;
        uint256 operationalBudget;
        uint256 completedRescues;
        UnitStatus status;
    }

    mapping(uint256 => RescueUnit) public rescueUnits;
    uint256 public unitCount;

    event UnitRegistered(uint256 indexed unitId, string teamName, address indexed leader);
    event FundsDispatched(uint256 indexed unitId, uint256 amount, string missionDetails);
    event RescueCompleted(uint256 indexed unitId, uint256 totalRescues);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner permitted");
        _;
    }

    constructor(address _trustIntegrator) {
        require(_trustIntegrator != address(0), "Invalid integrator address");
        owner = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function registerRescueUnit(string calldata teamName, address leader) external onlyOwner returns (uint256 unitId) {
        require(leader != address(0), "Invalid leader address");

        unitId = ++unitCount;
        rescueUnits[unitId] = RescueUnit({
            teamName: teamName, leader: leader, operationalBudget: 0, completedRescues: 0, status: UnitStatus.Active
        });

        emit UnitRegistered(unitId, teamName, leader);
    }

    function fundAndDispatchUnit(uint256 unitId, string calldata missionDetails) external payable onlyOwner {
        RescueUnit storage unit = rescueUnits[unitId];
        require(unit.status == UnitStatus.Active || unit.status == UnitStatus.OnStandby, "Unit not active");
        require(msg.value > 0, "Must assign budget for dispatch");

        unit.operationalBudget += msg.value;
        unit.status = UnitStatus.Dispatched;

        (bool success,) = payable(unit.leader).call{value: msg.value}("");
        require(success, "Fund transfer failed");

        emit FundsDispatched(unitId, msg.value, missionDetails);
    }

    function verifyRescueCompletion(uint256 unitId) external onlyOwner {
        RescueUnit storage unit = rescueUnits[unitId];
        require(unit.status == UnitStatus.Dispatched, "Unit is not currently dispatched");

        unit.completedRescues++;
        unit.status = UnitStatus.OnStandby;

        trustIntegrator.logPositiveAction(unit.leader, 2); // 2 = Emergency Rescue Action

        emit RescueCompleted(unitId, unit.completedRescues);
    }
}
