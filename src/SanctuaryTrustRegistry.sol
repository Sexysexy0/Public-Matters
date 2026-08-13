// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SanctuaryTrustRegistry {
    struct NodeState {
        bool isSanctuaryActive;
        uint256 interactionCooldown;
        uint256 lastInteractionBlock;
    }

    mapping(address => NodeState) public nodes;
    mapping(address => mapping(address => bool)) public permittedPeers;

    event SanctuaryConfigured(address indexed node, bool active);
    event PeerPermitted(address indexed node, address indexed peer);
    event DirectSignalSent(address indexed sender, address indexed recipient, bytes32 signalHash);

    error SanctuaryLocked();
    error CooldownActive();
    error UnauthorizedPeer();

    modifier onlyPermitted(address _recipient) {
        if (nodes[_recipient].isSanctuaryActive && !permittedPeers[_recipient][msg.sender]) {
            revert UnauthorizedPeer();
        }
        uint256 secondsPerBlock = 12;
        if (
            (block.number - nodes[_recipient].lastInteractionBlock) * secondsPerBlock
                < nodes[_recipient].interactionCooldown
        ) {
            revert CooldownActive();
        }
        _;
    }

    function setSanctuaryState(bool _active, uint256 _cooldown) external {
        nodes[msg.sender].isSanctuaryActive = _active;
        nodes[msg.sender].interactionCooldown = _cooldown;
        emit SanctuaryConfigured(msg.sender, _active);
    }

    function grantAccess(address _peer) external {
        permittedPeers[msg.sender][_peer] = true;
        emit PeerPermitted(msg.sender, _peer);
    }

    function sendSignal(address _recipient, bytes32 _signalHash) external onlyPermitted(_recipient) {
        nodes[_recipient].lastInteractionBlock = block.number;
        emit DirectSignalSent(msg.sender, _recipient, _signalHash);
    }
}
