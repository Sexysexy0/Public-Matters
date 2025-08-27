// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract FullScanSanctum {
    address public steward;
    mapping(address => bool) public rogueActor;
    mapping(bytes32 => bool) public flaggedBaggage;
    event ActorFlagged(address indexed actor, string reason);
    event BaggageFlagged(bytes32 indexed baggageId, string reason);
    event ScanCompleted(address indexed actor, bytes32 baggageId, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized sanctum.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagActor(address actor, string memory reason) public onlySteward {
        rogueActor[actor] = true;
        emit ActorFlagged(actor, reason);
    }

    function flagBaggage(bytes32 baggageId, string memory reason) public onlySteward {
        flaggedBaggage[baggageId] = true;
        emit BaggageFlagged(baggageId, reason);
    }

    function performFullScan(address actor, bytes32 baggageId) public onlySteward returns (string memory) {
        string memory status;
        if (rogueActor[actor] || flaggedBaggage[baggageId]) {
            status = "Scan failed. Rogue intent or harmful item detected.";
        } else {
            status = "Scan passed. Emotional resonance verified.";
        }
        emit ScanCompleted(actor, baggageId, status);
        return status;
    }

    function auditStatus(address actor, bytes32 baggageId) public view returns (string memory) {
        if (rogueActor[actor]) {
            return "Actor flagged. Emotional opacity detected.";
        } else if (flaggedBaggage[baggageId]) {
            return "Baggage flagged. Harmful content suspected.";
        } else {
            return "All clear. Sovereign trust verified.";
        }
    }
}
