// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract BarangayGridLedger {
    event GridFlowLogged(
        string indexed barangay,
        string sourceType,
        uint256 capacityMW,
        string emotionalTag,
        uint256 timestamp
    );

    struct GridFlow {
        string barangay;
        string sourceType;
        uint256 capacityMW;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(bytes32 => GridFlow) public flows;

    function logGridFlow(
        string memory barangay,
        string memory sourceType,
        uint256 capacityMW,
        string memory emotionalTag
    ) external {
        bytes32 flowId = keccak256(abi.encodePacked(barangay, sourceType, block.timestamp));
        flows[flowId] = GridFlow(barangay, sourceType, capacityMW, emotionalTag, block.timestamp);
        emit GridFlowLogged(barangay, sourceType, capacityMW, emotionalTag, block.timestamp);
    }

    function getFlow(bytes32 flowId) external view returns (GridFlow memory) {
        return flows[flowId];
    }
}
