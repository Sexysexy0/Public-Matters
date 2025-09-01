// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract FreezeAlertOracle {
    event SuspiciousFlowDetected(
        address indexed steward,
        uint256 amount,
        string origin,
        string emotionalTag,
        uint256 timestamp
    );

    struct SuspiciousFlow {
        address steward;
        uint256 amount;
        string origin;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(bytes32 => SuspiciousFlow) public alerts;
    address public validator;

    modifier onlyValidator() {
        require(msg.sender == validator, "Unauthorized sanctum");
        _;
    }

    constructor(address _validator) {
        validator = _validator;
    }

    function detectSuspiciousFlow(
        address steward,
        uint256 amount,
        string memory origin,
        string memory emotionalTag
    ) external onlyValidator {
        bytes32 alertId = keccak256(abi.encodePacked(steward, block.timestamp));
        alerts[alertId] = SuspiciousFlow(steward, amount, origin, emotionalTag, block.timestamp);
        emit SuspiciousFlowDetected(steward, amount, origin, emotionalTag, block.timestamp);
    }

    function getAlert(bytes32 alertId) external view returns (SuspiciousFlow memory) {
        return alerts[alertId];
    }
}
