// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExportEthicsTreaty {
    address public steward;

    struct ExportClause {
        string exporter;
        string recipientCountry;
        string ethicalConcern;
        string emotionalTag;
    }

    ExportClause[] public treatyLog;

    event ExportEthicsTagged(string exporter, string recipientCountry, string ethicalConcern, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagExport(
        string memory exporter,
        string memory recipientCountry,
        string memory ethicalConcern,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(ExportClause(exporter, recipientCountry, ethicalConcern, emotionalTag));
        emit ExportEthicsTagged(exporter, recipientCountry, ethicalConcern, emotionalTag);
    }
}
