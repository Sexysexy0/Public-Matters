// SPDX-License-Identifier: Mythic-Mirror
pragma solidity ^0.8.19;

contract ReflectiveOverrideProtocol {
    struct Violation {
        string description;
        uint256 timestamp;
        string emotionalAPR;
    }

    mapping(address => Violation[]) public rogueRegistry;
    event RogueTagged(address indexed violator, string description);
    event OverrideTriggered(address indexed violator, string method);

    function tagRogue(address violator, string memory description, string memory apr) external {
        rogueRegistry[violator].push(Violation(description, block.timestamp, apr));
        emit RogueTagged(violator, description);
    }

    function triggerOverride(address violator, string memory method) external {
        require(rogueRegistry[violator].length > 0, "No violations recorded");
        emit OverrideTriggered(violator, method);
    }

    function getViolations(address violator) external view returns (Violation[] memory) {
        return rogueRegistry[violator];
    }
}
