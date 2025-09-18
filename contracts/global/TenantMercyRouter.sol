// SPDX-License-Identifier: ShelterMercy
pragma solidity ^0.8.19;

contract TenantMercyRouter {
    address public steward;

    struct MercySignal {
        string tenantID;
        string propertyID;
        string mercyType; // e.g. "Rent Relief", "Eviction Deterrence", "Extension Granted"
        string reason; // e.g. "Job Loss", "Medical Emergency", "Calamity"
        bool verified;
        uint256 timestamp;
    }

    MercySignal[] public signals;

    event MercyLogged(string tenantID, string propertyID, string mercyType, string reason, uint256 timestamp);
    event MercyVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logMercy(
        string memory tenantID,
        string memory propertyID,
        string memory mercyType,
        string memory reason
    ) public {
        signals.push(MercySignal(tenantID, propertyID, mercyType, reason, false, block.timestamp));
        emit MercyLogged(tenantID, propertyID, mercyType, reason, block.timestamp);
    }

    function verifyMercy(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit MercyVerified(index, msg.sender);
    }

    function getMercy(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        MercySignal memory m = signals[index];
        return (m.tenantID, m.propertyID, m.mercyType, m.reason, m.verified, m.timestamp);
    }

    function totalMercySignals() public view returns (uint256) {
        return signals.length;
    }
}
