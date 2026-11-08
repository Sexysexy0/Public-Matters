// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

contract ShipAutoPilotRegistry {
    OperatorPrivileges public immutable privileges;
    
    struct AutoPilot {
        bytes32 shipId;
        bytes32 destinationHash;
        bool isEngaged;
        uint256 updatedAt;
    }
    
    mapping(bytes32 => AutoPilot) public pilots;
    
    event AutoPilotEngaged(bytes32 indexed shipId, bytes32 indexed destinationHash);
    event AutoPilotDisengaged(bytes32 indexed shipId);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function setDestination(bytes32 shipId, bytes32 destinationHash) external onlyOperator {
        pilots[shipId] = AutoPilot({
            shipId: shipId,
            destinationHash: destinationHash,
            isEngaged: true,
            updatedAt: block.timestamp
        });
        emit AutoPilotEngaged(shipId, destinationHash);
    }

    function getAutoPilot(bytes32 shipId) external view returns (AutoPilot memory) {
        return pilots[shipId];
    }

    function disengageAutoPilot(bytes32 shipId) external onlyOperator {
        require(pilots[shipId].isEngaged, "Auto-pilot not engaged");
        pilots[shipId].isEngaged = false;
        pilots[shipId].updatedAt = block.timestamp;
        emit AutoPilotDisengaged(shipId);
    }
}
