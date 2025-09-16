// SPDX-License-Identifier: MediaSanctum
pragma solidity ^0.8.19;

contract MediaIntegrityRouter {
    struct MediaSignal {
        string outletID;
        string fundingSource;
        bool editorialIndependent;
        string integrityScore;
        string stewardNote;
    }

    mapping(string => MediaSignal) public integrityLedger;

    event IntegrityTagged(string outletID, string integrityScore);
    event IndependenceVerified(string outletID);

    function tagIntegrity(string memory outletID, string memory fundingSource, string memory integrityScore, string memory stewardNote) public {
        integrityLedger[outletID] = MediaSignal(outletID, fundingSource, false, integrityScore, stewardNote);
        emit IntegrityTagged(outletID, integrityScore);
    }

    function verifyIndependence(string memory outletID) public {
        require(bytes(integrityLedger[outletID].fundingSource).length > 0, "Outlet not tagged");
        integrityLedger[outletID].editorialIndependent = true;
        emit IndependenceVerified(outletID);
    }

    function getIntegrityStatus(string memory outletID) public view returns (MediaSignal memory) {
        return integrityLedger[outletID];
    }
}
