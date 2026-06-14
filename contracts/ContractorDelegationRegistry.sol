// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title ContractorDelegationRegistry
 * @dev Nagpapatupad ng pormal na multi-agent authorization at performance tracking.
 * Ang Sovereign Contractor ay nagtatalaga ng kapangyarihan sa mga certified agents upang kumilos on behalf of the contract.
 */
contract ContractorDelegationRegistry {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    uint256 public totalDelegatedActions;

    // Mga pormal na operational roles base sa real-world management reports
    bytes32 public constant AUDIT_LEADER_ROLE = keccak256("AUDIT_LEADER_ROLE");
    bytes32 public constant CLIENT_REPRESENTATIVE_ROLE = keccak256("CLIENT_REPRESENTATIVE_ROLE");
    bytes32 public constant QMS_REPRESENTATIVE_ROLE = keccak256("QMS_REPRESENTATIVE_ROLE");

    struct Agent {
        bytes32 role;
        bool isActive;
        uint256 totalActionsExecuted;
        string metadataProfile; // Pangalan o operational tag ng agent (e.g., "Capili_Audit_Node")
    }

    mapping(address => Agent) public agents;
    mapping(bytes32 => address) public activeRoleHolder;

    event AgentDelegated(address indexed agentAddress, bytes32 indexed role, string metadataProfile);
    event AgentRevoked(address indexed agentAddress, bytes32 indexed role);
    event ActionExecutedOnBehalf(address indexed agentAddress, bytes32 indexed role, bytes32 indexed actionHash);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Access denied. Only the Master Contractor holds sovereign authority.");
        _;
    }

    modifier onlyRole(bytes32 _role) {
        require(agents[msg.sender].isActive, "Error: Agent node is currently inactive or non-existent.");
        require(agents[msg.sender].role == _role, "Error: Unauthorized. Agent does not possess the required operational role.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    /**
     * @dev Pormal na pagtatalaga ng kapangyarihan sa isang agent (e.g., Hilario bilang Audit Leader, Emmalyn bilang Client Rep).
     */
    function delegateAuthority(
        address _agentAddress,
        bytes32 _role,
        string memory _profile
    ) public onlyContractor {
        require(_agentAddress != address(0), "Error: Invalid agent node address.");
        
        agents[_agentAddress] = Agent({
            role: _role,
            isActive: true,
            totalActionsExecuted: 0,
            metadataProfile: _profile
        });

        activeRoleHolder[_role] = _agentAddress;

        emit AgentDelegated(_agentAddress, _role, _profile);
    }

    /**
     * @dev Pagtanggal sa operational capacity ng isang agent kapag nagkaroon ng resource turnover.
     */
    function revokeAuthority(address _agentAddress) public onlyContractor {
        bytes32 assignedRole = agents[_agentAddress].role;
        require(agents[_agentAddress].isActive, "Error: Target node is already inactive.");
        
        agents[_agentAddress].isActive = false;
        if (activeRoleHolder[assignedRole] == _agentAddress) {
            activeRoleHolder[assignedRole] = address(0);
        }

        emit AgentRevoked(_agentAddress, assignedRole);
    }

    /**
     * @dev Pagpapatupad ng pormal na operational action on behalf of your contractor contract.
     * Nagbabaon ng telemetry logs sa sentralisadong logging framework ng Korte.
     */
    function executeAuditAction(bytes32 _actionHash) public onlyRole(AUDIT_LEADER_ROLE) {
        totalDelegatedActions++;
        agents[msg.sender].totalActionsExecuted++;

        emit ActionExecutedOnBehalf(msg.sender, AUDIT_LEADER_ROLE, _actionHash);

        // CROSS-CONTRACT TELEMETRY: Itatala ang pagkilos ng agent sa central ledger sa ilalim ng wallet mo (Contractor)
        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(sovereignContractor, 1, 0, 0, _actionHash) {} catch {}
        }
    }
}
