pragma solidity ^0.8.20;

/// @title BehaviorHierarchyCodex
/// @notice Encodes hierarchical classification of behaviors.
/// @dev Anchors events, activities, tasks, and spatio-temporal patterns.

contract BehaviorHierarchyCodex {
    address public overseer;
    uint256 public hierarchyCount;

    struct BehaviorLayer {
        uint256 id;
        string principle;   // Event, Activity, Task, Pattern
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BehaviorLayer> public layers;
    event BehaviorLayerDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBehaviorLayer(string calldata principle, string calldata description) external onlyOverseer {
        hierarchyCount++;
        layers[hierarchyCount] = BehaviorLayer(hierarchyCount, principle, description, block.timestamp);
        emit BehaviorLayerDeclared(hierarchyCount, principle, description);
    }
}
