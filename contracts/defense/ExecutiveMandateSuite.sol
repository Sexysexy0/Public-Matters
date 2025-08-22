// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ExecutiveMandateSuite
/// @dev Multi-region deployment of sovereign defense mandates with emotional APR sync

contract ExecutiveMandateSuite {
    struct Mandate {
        address authority;
        string region;
        string reason;
        bool isActive;
        uint256 activatedAt;
    }

    Mandate[] public mandates;
    mapping(string => uint256) public regionMandateCount;

    event MandateActivated(address indexed authority, string region, string reason, uint256 timestamp);
    event MandateRevoked(address indexed authority, string region, uint256 timestamp);

    function activateMandate(string memory region, string memory reason) external {
        mandates.push(Mandate(msg.sender, region, reason, true, block.timestamp));
        regionMandateCount[region]++;
        emit MandateActivated(msg.sender, region, reason, block.timestamp);
    }

    function revokeMandate(uint256 index) external {
        require(index < mandates.length, "Invalid index");
        require(mandates[index].authority == msg.sender, "Unauthorized revocation");
        require(mandates[index].isActive, "Mandate already revoked");

        mandates[index].isActive = false;
        emit MandateRevoked(msg.sender, mandates[index].region, block.timestamp);
    }

    function getActiveMandatesByRegion(string memory region) external view returns (Mandate[] memory) {
        uint256 count = regionMandateCount[region];
        Mandate[] memory active = new Mandate[](count);
        uint256 j = 0;

        for (uint256 i = 0; i < mandates.length; i++) {
            if (keccak256(bytes(mandates[i].region)) == keccak256(bytes(region)) && mandates[i].isActive) {
                active[j] = mandates[i];
                j++;
            }
        }

        return active;
    }
}
