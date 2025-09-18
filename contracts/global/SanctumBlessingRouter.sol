// SPDX-License-Identifier: SanctumBlessing
pragma solidity ^0.8.19;

contract SanctumBlessingRouter {
    address public steward;

    struct SanctumSignal {
        string sanctumID;
        string region;
        string blessingStatus; // "Pending", "Blessed", "Activated"
        string patientTag; // e.g. "CSP #1023"
        bool verified;
        uint256 timestamp;
    }

    SanctumSignal[] public signals;

    event SanctumLogged(string sanctumID, string region, string blessingStatus, string patientTag, uint256 timestamp);
    event SanctumVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSanctum(
        string memory sanctumID,
        string memory region,
        string memory blessingStatus,
        string memory patientTag
    ) public {
        signals.push(SanctumSignal(sanctumID, region, blessingStatus, patientTag, false, block.timestamp));
        emit SanctumLogged(sanctumID, region, blessingStatus, patientTag, block.timestamp);
    }

    function verifySanctum(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit SanctumVerified(index, msg.sender);
    }

    function getSanctum(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        SanctumSignal memory s = signals[index];
        return (s.sanctumID, s.region, s.blessingStatus, s.patientTag, s.verified, s.timestamp);
    }

    function totalSanctumSignals() public view returns (uint256) {
        return signals.length;
    }
}
