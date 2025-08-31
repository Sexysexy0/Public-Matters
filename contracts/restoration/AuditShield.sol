// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract AuditShield {
    struct ProtectionRequest {
        address auditor;
        string threatType;
        string location;
        string emotionalState;
        uint256 timestamp;
    }

    ProtectionRequest[] public requests;

    event ShieldActivated(address indexed auditor, string threatType, string location, string emotionalState);

    function requestShield(
        string memory threatType,
        string memory location,
        string memory emotionalState
    ) public {
        requests.push(ProtectionRequest(msg.sender, threatType, location, emotionalState, block.timestamp));
        emit ShieldActivated(msg.sender, threatType, location, emotionalState);
    }

    function getAllRequests() public view returns (ProtectionRequest[] memory) {
        return requests;
    }
}
