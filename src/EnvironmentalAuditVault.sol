// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract EnvironmentalAuditVault {
    address public steward;
    uint256 private validationNonce;

    event ReportLogged(bytes32 indexed reportId, address indexed submitter, bytes32 facilityId);

    constructor() {
        steward = msg.sender;
    }

    function submitAuditReport(bytes32 facilityId) external returns (bytes32 reportId) {
        validationNonce++;
        // forge-lint: disable-next-line(weak-prng)
        reportId = keccak256(abi.encodePacked(msg.sender, facilityId, block.timestamp, validationNonce));
        emit ReportLogged(reportId, msg.sender, facilityId);
    }
}
