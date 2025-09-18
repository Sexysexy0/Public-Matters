// SPDX-License-Identifier: CustomsSanctum
pragma solidity ^0.8.19;

contract CustomsOverrideRouter {
    address public steward;

    struct OverrideSignal {
        string shipmentID;
        string customsJurisdiction; // e.g. "NAIA", "Port of Cebu", "Clark"
        string breachType; // "Seizure", "Delay", "Inspection Abuse"
        string overrideAction; // "Treaty Release", "Scrollchain Blessing", "Medicinal Clearance"
        bool verified;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event OverrideLogged(string shipmentID, string customsJurisdiction, string breachType, string overrideAction, uint256 timestamp);
    event OverrideVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logOverride(
        string memory shipmentID,
        string memory customsJurisdiction,
        string memory breachType,
        string memory overrideAction
    ) public {
        signals.push(OverrideSignal(shipmentID, customsJurisdiction, breachType, overrideAction, false, block.timestamp));
        emit OverrideLogged(shipmentID, customsJurisdiction, breachType, overrideAction, block.timestamp);
    }

    function verifyOverride(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit OverrideVerified(index, msg.sender);
    }

    function getOverride(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        OverrideSignal memory o = signals[index];
        return (o.shipmentID, o.customsJurisdiction, o.breachType, o.overrideAction, o.verified, o.timestamp);
    }

    function totalOverrideSignals() public view returns (uint256) {
        return signals.length;
    }
}
