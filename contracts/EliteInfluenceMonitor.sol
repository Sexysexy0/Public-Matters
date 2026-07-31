// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title EliteInfluenceMonitor
 * @notice An Inner Telescope contract that monitors and flags suspicious systemic policy shifts.
 * @dev Upgraded with Sybil-resistance (Informant roles) and automated audit triggers.
 */
contract EliteInfluenceMonitor is Ownable {
    
    struct InfluenceAlert {
        string topic;               // e.g., "Arctic Security"
        uint256 volatilityIndex;    // 0-100 gauge of suspicious activity
        string suspectedPolicy;     // e.g., "Increased Military Spending"
        bool requiresPublicAudit;   // Triggered if volatility > 75
        address informant;          // The verified watcher who logged this
        uint256 timestamp;
    }

    mapping(uint256 => InfluenceAlert) public alerts;
    uint256 public alertCount;

    // The Inner Telescope Guard: Only whitelisted addresses can submit logs
    mapping(address => bool) public authorizedInformants;

    event InformantAuthorized(address indexed informant);
    event InformantRevoked(address indexed informant);
    event ObservationLogged(uint256 indexed alertId, string topic, uint256 volatility, bool auditTriggered);
    event SystemFreezeTriggered(uint256 indexed alertId, string policy);

    // Pass msg.sender to the Ownable constructor (Standard for OpenZeppelin v5)
    constructor() Ownable(msg.sender) {}

    /**
     * @notice Restricts logging strictly to authorized Watchers/Informants
     */
    modifier onlyInformant() {
        require(
            authorizedInformants[msg.sender] || msg.sender == owner(),
            "Unauthorized: Only verified Informants or Chief Operator can log observations."
        );
        _;
    }

    // --- CHIEF OPERATOR CONTROLS ---

    function authorizeInformant(address _informant) external onlyOwner {
        authorizedInformants[_informant] = true;
        emit InformantAuthorized(_informant);
    }

    function revokeInformant(address _informant) external onlyOwner {
        authorizedInformants[_informant] = false;
        emit InformantRevoked(_informant);
    }

    // --- THE TELESCOPE LENS ---

    /**
     * @notice Logs a systemic shift observation. Triggers an audit state if threshold is breached.
     */
    function logObservation(string memory _topic, uint256 _volatility, string memory _policy) external onlyInformant {
        alertCount++;
        bool audit = (_volatility > 75); // The Glitch Threshold

        alerts[alertCount] = InfluenceAlert({
            topic: _topic,
            volatilityIndex: _volatility,
            suspectedPolicy: _policy,
            requiresPublicAudit: audit,
            informant: msg.sender,
            timestamp: block.timestamp
        });

        emit ObservationLogged(alertCount, _topic, _volatility, audit);

        // If the volatility breaches the threshold, it triggers a systemic alarm
        if (audit) {
            emit SystemFreezeTriggered(alertCount, _policy);
            // Future Integration: Call an external router here to freeze politician escrows or data center funding
        }
    }
}
