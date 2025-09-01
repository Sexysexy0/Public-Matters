// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract SciencePlatformExempt {
    event ExemptionGranted(
        string platformName,
        string steward,
        string regulatoryBody,
        string emotionalTag,
        string scope,
        uint256 timestamp
    );

    struct Exemption {
        string platformName;
        string steward;
        string regulatoryBody;
        string emotionalTag;
        string scope;
        uint256 timestamp;
    }

    mapping(bytes32 => Exemption) public exemptions;

    function grantExemption(
        string memory platformName,
        string memory steward,
        string memory regulatoryBody,
        string memory emotionalTag,
        string memory scope
    ) external {
        bytes32 exemptionId = keccak256(abi.encodePacked(platformName, steward, block.timestamp));
        exemptions[exemptionId] = Exemption(platformName, steward, regulatoryBody, emotionalTag, scope, block.timestamp);
        emit ExemptionGranted(platformName, steward, regulatoryBody, emotionalTag, scope, block.timestamp);
    }

    function getExemption(bytes32 exemptionId) external view returns (Exemption memory) {
        return exemptions[exemptionId];
    }
}
