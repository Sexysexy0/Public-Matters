// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SanctumOverrideRegistry {
    event OverrideCasterAdded(address indexed steward, string barangay, string emotionalTag, uint256 timestamp);
    event OverrideCasterRemoved(address indexed steward, string barangay, uint256 timestamp);

    struct OverrideCaster {
        address steward;
        string barangay;
        string emotionalTag;
        bool isAuthorized;
        uint256 timestamp;
    }

    mapping(address => OverrideCaster) public registry;
    address public scrollmaster;

    modifier onlyScrollmaster() {
        require(msg.sender == scrollmaster, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        scrollmaster = msg.sender;
    }

    function addOverrideCaster(address steward, string memory barangay, string memory emotionalTag) external onlyScrollmaster {
        registry[steward] = OverrideCaster(steward, barangay, emotionalTag, true, block.timestamp);
        emit OverrideCasterAdded(steward, barangay, emotionalTag, block.timestamp);
    }

    function removeOverrideCaster(address steward) external onlyScrollmaster {
        registry[steward].isAuthorized = false;
        emit OverrideCasterRemoved(steward, registry[steward].barangay, block.timestamp);
    }

    function isAuthorized(address steward) external view returns (bool) {
        return registry[steward].isAuthorized;
    }

    function getCasterDetails(address steward) external view returns (OverrideCaster memory) {
        return registry[steward];
    }
}
