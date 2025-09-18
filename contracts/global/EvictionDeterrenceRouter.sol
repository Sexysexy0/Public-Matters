// SPDX-License-Identifier: TenantSanctum
pragma solidity ^0.8.19;

contract EvictionDeterrenceRouter {
    address public steward;

    struct DeterrenceSignal {
        string tenantID;
        string propertyID;
        string deterrenceType; // e.g. "Extension Granted", "Eviction Blocked", "Lease Reinforced"
        string reason; // e.g. "Medical Emergency", "Job Loss", "Calamity", "Lease Valid"
        bool verified;
        uint256 timestamp;
    }

    DeterrenceSignal[] public signals;

    event DeterrenceLogged(string tenantID, string propertyID, string deterrenceType, string reason, uint256 timestamp);
    event DeterrenceVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logDeterrence(
        string memory tenantID,
        string memory propertyID,
        string memory deterrenceType,
        string memory reason
    ) public {
        signals.push(DeterrenceSignal(tenantID, propertyID, deterrenceType, reason, false, block.timestamp));
        emit DeterrenceLogged(tenantID, propertyID, deterrenceType, reason, block.timestamp);
    }

    function verifyDeterrence(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit DeterrenceVerified(index, msg.sender);
    }

    function getDeterrence(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        DeterrenceSignal memory d = signals[index];
        return (d.tenantID, d.propertyID, d.deterrenceType, d.reason, d.verified, d.timestamp);
    }

    function totalDeterrenceSignals() public view returns (uint256) {
        return signals.length;
    }
}
