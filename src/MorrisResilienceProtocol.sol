// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title MorrisResilienceProtocol
 * @notice Isang on-chain na depensa para sa mga kritikal na imprastruktura upang 
 * awtomatikong magpatupad ng circuit breaker at i-isolate ang network kapag may detect na mabilis na pagkalat ng payload.
 */
contract MorrisResilienceProtocol {

    address public immutable networkSteward;
    bool public systemLocked;
    
    mapping(address => uint256) public nodeRequestCounts;
    mapping(address => bool) public blacklistedNodes;
    
    uint256 public constant REPLICATION_THRESHOLD = 5; // Max allowed requests bago ma-flag bilang worm-like behavior

    event SystemEmergencyLocked(address indexed triggeringNode, string reason);
    event NodeBlacklisted(address indexed node);
    event SystemResumed(address indexed steward);

    modifier onlySteward() {
        require(msg.sender == networkSteward, "Unauthorized steward access");
        _;
    }

    modifier whenNotLocked() {
        require(!systemLocked, "System is under emergency lockdown due to worm-like propagation");
        _;
    }

    constructor(address _networkSteward) {
        networkSteward = _networkSteward;
        systemLocked = false;
    }

    /**
     * @notice Awtomatikong i-monitor ang aktibidad ng mga node at i-trigger ang circuit breaker kapag lumagpas sa threshold
     */
    function monitorAndVerifyNode(address _node) external whenNotLocked {
        require(!blacklistedNodes[_node], "Node is blacklisted");

        nodeRequestCounts[_node]++;

        if (nodeRequestCounts[_node] > REPLICATION_THRESHOLD) {
            systemLocked = true;
            blacklistedNodes[_node] = true;
            emit SystemEmergencyLocked(_node, "Worm-like rapid replication detected. Circuit breaker activated.");
            emit NodeBlacklisted(_node);
        }
    }

    /**
     * @notice I-resibo at i-reset ng steward ang sistema matapos malunasan ang banta
     */
    function resumeSystem() external onlySteward {
        systemLocked = false;
        emit SystemResumed(msg.sender);
    }
}
