// SPDX-License-Identifier: MedicinalSanctum
pragma solidity ^0.8.19;

contract DispensaryBlessingRouter {
    address public steward;

    struct DispensarySignal {
        string dispensaryID;
        string region;
        string blessingStatus; // "Pending", "Blessed", "Activated"
        string growerTag; // e.g. "LegacyGrower #7"
        bool verified;
        uint256 timestamp;
    }

    DispensarySignal[] public signals;

    event DispensaryLogged(string dispensaryID, string region, string blessingStatus, string growerTag, uint256 timestamp);
    event DispensaryVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logDispensary(
        string memory dispensaryID,
        string memory region,
        string memory blessingStatus,
        string memory growerTag
    ) public {
        signals.push(DispensarySignal(dispensaryID, region, blessingStatus, growerTag, false, block.timestamp));
        emit DispensaryLogged(dispensaryID, region, blessingStatus, growerTag, block.timestamp);
    }

    function verifyDispensary(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit DispensaryVerified(index, msg.sender);
    }

    function getDispensary(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        DispensarySignal memory d = signals[index];
        return (d.dispensaryID, d.region, d.blessingStatus, d.growerTag, d.verified, d.timestamp);
    }

    function totalDispensarySignals() public view returns (uint256) {
        return signals.length;
    }
}
