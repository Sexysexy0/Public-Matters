// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StewardSuccessionRegistry
 * @notice Enforces strict multi-stage leadership transitions and lineage key validation delays to guarantee systemic preservation across operational eras.
 */
contract StewardSuccessionRegistry {
    event SuccessionNominated(address indexed currentSteward, address indexed nominatedSuccessor, uint256 activationBlockEta);
    event SuccessionFinalized(address indexed oldSteward, address indexed newSteward, uint256 currentEraIndex);
    event NominationRevoked(address indexed stewardRoot, address indexed canceledSuccessor);

    address public activeStewardRoot;
    address public nominatedSuccessorNode;
    
    uint256 public eraIndex;
    uint256 public transitionBlockEta;
    uint256 public constant MANDATORY_TRANSITION_WINDOW = 300; // Block length delay requirement to prevent rapid governance hijacking
    bool public nominationActive;

    // Lineage registry mapping tracking historical era masters
    mapping(uint256 => address) public lineageHistoryLog;

    constructor() {
        activeStewardRoot = msg.sender;
        lineageHistoryLog[0] = msg.sender;
    }

    modifier onlyActiveSteward() {
        require(msg.sender == activeStewardRoot, "Identity Fault: Active steward signature validation trace failed");
        _;
    }

    modifier onlyNominatedSuccessor() {
        require(msg.sender == nominatedSuccessorNode, "Access Denied: Caller identity does not match current nominated successor token");
        _;
    }

    /**
     * @notice Nominate a secondary infrastructure node to assume the master steward role after the cooldown threshold clears.
     */
    function nominateSuccessor(address _successorNode, uint256 _blockDelay) external onlyActiveSteward {
        require(_successorNode != address(0), "Parameter Error: Target successor coordinate cannot be blank registry space");
        require(_successorNode != activeStewardRoot, "Logic Error: Master entity cannot nominate the active processing address");
        require(!nominationActive, "State Block: Active nomination track already occupying system queue registers");

        uint256 finalWindow = _blockDelay < MANDATORY_TRANSITION_WINDOW ? MANDATORY_TRANSITION_WINDOW : _blockDelay;
        
        nominatedSuccessorNode = _successorNode;
        transitionBlockEta = block.number + finalWindow;
        nominationActive = true;

        emit SuccessionNominated(msg.sender, _successorNode, transitionBlockEta);
    }

    /**
     * @notice Finalizes the leadership transition sequence once the block confirmation constraints are fully cleared.
     */
    function finalizeSuccession() external onlyNominatedSuccessor {
        require(nominationActive, "State Error: Succession pipeline is currently uninstantiated inside memory");
        require(block.number >= transitionBlockEta, "Temporal Guard: Forced transition window buffer period is currently active");

        address oldSteward = activeStewardRoot;
        activeStewardRoot = nominatedSuccessorNode;
        
        eraIndex += 1;
        lineageHistoryLog[eraIndex] = nominatedSuccessorNode;
        
        // Purge temporary nomination memory registries
        nominatedSuccessorNode = address(0);
        transitionBlockEta = 0;
        nominationActive = false;

        emit SuccessionFinalized(oldSteward, activeStewardRoot, eraIndex);
    }

    /**
     * @notice Emergency administrative function to instantly revoke a nomination track before it merges into active configurations.
     */
    function revokeNomination() external onlyActiveSteward {
        require(nominationActive, "State Error: No active succession paths found inside active tracking memory");
        address canceledNode = nominatedSuccessorNode;
        
        nominatedSuccessorNode = address(0);
        transitionBlockEta = 0;
        nominationActive = false;

        emit NominationRevoked(msg.sender, canceledNode);
    }

    /**
     * @notice External view utility to audit historical node identity roots across previous system eras.
     */
    function getLineageAudit(uint256 _eraId) external view returns (address) {
        return lineageHistoryLog[_eraId];
    }
}
