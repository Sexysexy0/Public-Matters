// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EnvironmentalAuditVault {
    address public immutable coreAuditor;

    struct DischargeReport {
        address whistleblower;
        string facilityId;
        string chemicalDetails;
        uint256 wastewaterVolumeGallons;
        bool verified;
        uint256 timestamp;
    }

    mapping(bytes32 => DischargeReport) public reports;
    bytes32[] public reportIds;

    event ReportLogged(bytes32 indexed reportId, address indexed whistleblower, string facilityId);
    event ReportVerified(bytes32 indexed reportId, address indexed auditor);

    modifier onlyAuditor() {
        require(msg.sender == coreAuditor, "EnvironmentalAuditVault: Unauthorized auditor");
        _;
    }

    constructor() {
        coreAuditor = msg.sender;
    }

    function submitDischargeReport(string memory facilityId, string memory chemicalDetails, uint256 volumeGallons)
        external
        returns (bytes32)
    {
        bytes32 reportId = keccak256(abi.encodePacked(msg.sender, facilityId, block.timestamp));

        reports[reportId] = DischargeReport({
            whistleblower: msg.sender,
            facilityId: facilityId,
            chemicalDetails: chemicalDetails,
            wastewaterVolumeGallons: volumeGallons,
            verified: false,
            timestamp: block.timestamp
        });

        reportIds.push(reportId);
        emit ReportLogged(reportId, msg.sender, facilityId);
        return reportId;
    }

    function verifyReport(bytes32 reportId) external onlyAuditor {
        require(reports[reportId].timestamp > 0, "Report does not exist");
        reports[reportId].verified = true;
        emit ReportVerified(reportId, msg.sender);
    }
}
