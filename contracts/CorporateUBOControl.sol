// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../src/OperatorPrivileges.sol";

/**
 * @title CorporateUBOControl
 * @notice Registry of Ultimate Beneficial Ownership records per entity.
 *         Multiple UBOs per entity are supported. Aggregate ownership
 *         is enforced <= 10000 bps (100%). Verification requires an
 *         operator distinct from the recorder.
 */
contract CorporateUBOControl {
    struct UBORecord {
        address beneficiary;
        uint256 ownershipPercentage; // bps of total equity; 10000 = 100%
        bool    verified;
        address recorder;
        address verifier;
        string  entityName;
        uint256 timestamp;
    }

    OperatorPrivileges public immutable privileges;

    mapping(bytes32 => UBORecord[]) public uboRegistry;
    mapping(bytes32 => uint256) public totalPercentage;

    event UBORecorded(
        bytes32 indexed entityId,
        address indexed beneficiary,
        uint256 percentage,
        uint256 index
    );
    event UBOVerified(
        bytes32 indexed entityId,
        uint256 indexed index,
        address indexed verifier,
        bool status
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function recordUBO(
        bytes32 entityId,
        address beneficiary,
        uint256 percentage,
        string calldata entityName
    ) external onlyOperator returns (uint256) {
        require(entityId != bytes32(0), "entityId=0");
        require(beneficiary != address(0), "beneficiary=0");
        require(percentage > 0 && percentage <= 10000, "percentage out of range");
        require(totalPercentage[entityId] + percentage <= 10000, "aggregate exceeds 10000 bps");

        uint256 index = uboRegistry[entityId].length;
        uboRegistry[entityId].push(UBORecord({
            beneficiary: beneficiary,
            ownershipPercentage: percentage,
            verified: false,
            recorder: msg.sender,
            verifier: address(0),
            entityName: entityName,
            timestamp: block.timestamp
        }));
        totalPercentage[entityId] += percentage;

        emit UBORecorded(entityId, beneficiary, percentage, index);
        return index;
    }

    function verifyUBO(bytes32 entityId, uint256 index, bool status) external onlyOperator {
        require(index < uboRegistry[entityId].length, "UBO not found");
        UBORecord storage r = uboRegistry[entityId][index];
        require(r.recorder != msg.sender, "Verifier must differ from recorder");
        r.verified = status;
        r.verifier = msg.sender;
        emit UBOVerified(entityId, index, msg.sender, status);
    }

    function getUBOCount(bytes32 entityId) external view returns (uint256) {
        return uboRegistry[entityId].length;
    }

    function getUBO(bytes32 entityId, uint256 index) external view returns (UBORecord memory) {
        require(index < uboRegistry[entityId].length, "UBO not found");
        return uboRegistry[entityId][index];
    }

    function getEntitySummary(bytes32 entityId)
        external view returns (uint256 count, uint256 totalBps)
    {
        return (uboRegistry[entityId].length, totalPercentage[entityId]);
    }
}
