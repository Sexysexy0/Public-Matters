// SPDX-License-Identifier: TrustSanctum
pragma solidity ^0.8.19;

contract PoliticalTrustLedger {
    struct TrustEvent {
        string stewardName;
        string institution; // e.g., "Education", "Media", "Government"
        string trustMessage;
        bool verified;
        bool reconciled;
    }

    mapping(bytes32 => TrustEvent) public trustRegistry;

    event TrustRegistered(string stewardName, string institution);
    event TrustVerified(string stewardName);
    event ReconciliationCompleted(string stewardName);

    function registerTrustEvent(string memory stewardName, string memory institution, string memory trustMessage) public {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, institution, block.timestamp));
        trustRegistry[eventId] = TrustEvent(stewardName, institution, trustMessage, false, false);
        emit TrustRegistered(stewardName, institution);
    }

    function verifyTrust(string memory stewardName, string memory institution) public {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, institution, block.timestamp));
        trustRegistry[eventId].verified = true;
        emit TrustVerified(stewardName);
    }

    function completeReconciliation(string memory stewardName, string memory institution) public {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, institution, block.timestamp));
        trustRegistry[eventId].reconciled = true;
        emit ReconciliationCompleted(stewardName);
    }

    function getTrustStatus(string memory stewardName, string memory institution) public view returns (TrustEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(stewardName, institution, block.timestamp));
        return trustRegistry[eventId];
    }
}
