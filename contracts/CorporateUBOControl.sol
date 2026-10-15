// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CorporateUBOControl
 * @notice Manages Ultimate Beneficial Ownership (UBO) thresholds and corporate compliance mapping.
 */
contract CorporateUBOControl {
    struct UBORecord {
        address beneficiary;
        uint256 ownershipPercentage; // e.g., 2500 for 25.00%
        bool verified;
        string entityName;
    }

    mapping(bytes32 => UBORecord) public uboRegistry;
    address public immutable controller;

    event UBORecorded(bytes32 indexed entityId, address indexed beneficiary, uint256 percentage);
    event UBOVerified(bytes32 indexed entityId, bool status);

    modifier onlyController() {
        require(msg.sender == controller, "Unauthorized: Only controller");
        _;
    }

    constructor() {
        controller = msg.sender;
    }

    function recordUBO(
        bytes32 entityId,
        address beneficiary,
        uint256 percentage,
        string calldata entityName
    ) external onlyController {
        require(percentage <= 10000, "Invalid percentage: Max 10000 (100%)");
        uboRegistry[entityId] = UBORecord({
            beneficiary: beneficiary,
            ownershipPercentage: percentage,
            verified: false,
            entityName: entityName
        });
        emit UBORecorded(entityId, beneficiary, percentage);
    }

    function verifyUBO(bytes32 entityId, bool status) external onlyController {
        uboRegistry[entityId].verified = status;
        emit UBOVerified(entityId, status);
    }

    function getUBO(bytes32 entityId) external view returns (address, uint256, bool, string memory) {
        UBORecord memory r = uboRegistry[entityId];
        return (r.beneficiary, r.ownershipPercentage, r.verified, r.entityName);
    }
}
