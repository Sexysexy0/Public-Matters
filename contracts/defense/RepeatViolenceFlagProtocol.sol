// SPDX-License-Identifier: ViolenceFlag-License
pragma solidity ^0.8.0;

contract RepeatViolenceFlagProtocol {
    address public steward;

    struct Offender {
        string name;
        uint256 offenseCount;
        bool escaped;
        bool refusesReform;
        string status;
        uint256 timestamp;
    }

    Offender[] public flagged;

    event OffenderFlagged(string name, uint256 count, bool escaped, bool refusesReform, string status, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function flagOffender(string memory name, uint256 offenseCount, bool escaped, bool refusesReform) public {
        require(msg.sender == steward, "Only steward can flag");
        string memory status = (offenseCount >= 3 || escaped || refusesReform) ? "High Risk - Isolate" : "Monitor";
        flagged.push(Offender(name, offenseCount, escaped, refusesReform, status, block.timestamp));
        emit OffenderFlagged(name, offenseCount, escaped, refusesReform, status, block.timestamp);
    }

    function getFlag(uint index) public view returns (string memory, uint256, bool, bool, string memory, uint256) {
        Offender memory o = flagged[index];
        return (o.name, o.offenseCount, o.escaped, o.refusesReform, o.status, o.timestamp);
    }
}
