// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainJusticeRouter {
    struct JusticeCase {
        string caseId;
        string stewardName;
        string incidentType;
        string location;
        bool resolved;
        bool treatySummoned;
        uint256 timestamp;
    }

    mapping(string => JusticeCase) public justiceLedger;

    event JusticeSummoned(
        string caseId,
        string stewardName,
        string incidentType,
        string location,
        bool treatySummoned
    );

    function logCase(
        string memory caseId,
        string memory stewardName,
        string memory incidentType,
        string memory location,
        bool treatySummoned
    ) public {
        justiceLedger[caseId] = JusticeCase(
            caseId,
            stewardName,
            incidentType,
            location,
            false,
            treatySummoned,
            block.timestamp
        );

        emit JusticeSummoned(
            caseId,
            stewardName,
            incidentType,
            location,
            treatySummoned
        );
    }

    function resolveCase(string memory caseId) public {
        require(bytes(justiceLedger[caseId].caseId).length != 0, "Case not found");
        justiceLedger[caseId].resolved = true;
    }

    function getCaseDetails(string memory caseId) public view returns (JusticeCase memory) {
        return justiceLedger[caseId];
    }
}
