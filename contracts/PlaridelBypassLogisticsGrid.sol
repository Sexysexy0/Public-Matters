// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PlaridelBypassLogisticsGrid
 * @dev Enforces energy infrastructure development checkpoints for the MIDC Warehouse Network.
 */
contract PlaridelBypassLogisticsGrid {
    address public immutable executiveOversight;
    string public constant LOCATION = "Plaridel Bypass, Bulacan - MIDC Zone";
    
    enum GridPhase { GeneratorDependence, SubstationSurvey, BackboneCabling, EnergizedGrid }
    
    struct WarehouseNode {
        string nodeName;
        bool ventilationActive;
        bool permanentGridConnected;
    }

    GridPhase public currentPhase;
    WarehouseNode[] public warehouseNodes;
    uint256 public totalCapitalAllocated;

    event InfrastructurePhaseAdvanced(GridPhase indexed newPhase, string updates, uint256 timestamp);
    event WarehouseNodeRegistered(uint256 indexed nodeId, string nodeName);
    event GridPowerActivated(uint256 indexed nodeId, uint256 timestamp);
    event ExecutiveFundEmergencyOverride(address indexed recipient, uint256 amount, string justification);

    modifier onlyExecutive() {
        require(msg.sender == executiveOversight, "Oversight Error: Root Executive Privilege Required.");
        _;
    }

    constructor() {
        executiveOversight = msg.sender;
        currentPhase = GridPhase.GeneratorDependence;
    }

    function registerWarehouseNode(string memory _nodeName) external onlyExecutive {
        warehouseNodes.push(WarehouseNode({
            nodeName: _nodeName,
            ventilationActive: false,
            permanentGridConnected: false
        }));
        emit WarehouseNodeRegistered(warehouseNodes.length - 1, _nodeName);
    }

    function advanceGridPhase(GridPhase _nextPhase, string memory _updates) external onlyExecutive {
        currentPhase = _nextPhase;
        emit InfrastructurePhaseAdvanced(_nextPhase, _updates, block.timestamp);
    }

    function activateNodePermanentPower(uint256 _nodeId) external onlyExecutive {
        require(_nodeId < warehouseNodes.length, "Invalid Node ID.");
        WarehouseNode storage node = warehouseNodes[_nodeId];
        
        node.permanentGridConnected = true;
        node.ventilationActive = true; // Industrial cooling systems fully standard-compliant
        
        emit GridPowerActivated(_nodeId, block.timestamp);
    }

    function executeCorporateOverride(address payable _recipient, uint256 _amount, string memory _justification) external onlyExecutive {
        require(_amount <= address(this).balance, "Insufficient liquidity in infrastructure pool.");
        _recipient.transfer(_amount);
        emit ExecutiveFundEmergencyOverride(_recipient, _amount, _justification);
    }

    receive() external payable {
        totalCapitalAllocated += msg.value;
    }
}
