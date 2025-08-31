// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract TransparencyLedger {
    struct Publication {
        string title;
        string agency;
        string summary;
        string damayClause;
        string restorationPath;
        uint256 timestamp;
        address publisher;
    }

    Publication[] public reports;

    event ReportPublished(string title, string agency, string damayClause, string restorationPath, address indexed publisher);

    function publishReport(
        string memory title,
        string memory agency,
        string memory summary,
        string memory damayClause,
        string memory restorationPath
    ) public {
        reports.push(Publication(title, agency, summary, damayClause, restorationPath, block.timestamp, msg.sender));
        emit ReportPublished(title, agency, damayClause, restorationPath, msg.sender);
    }

    function getAllReports() public view returns (Publication[] memory) {
        return reports;
    }
}
