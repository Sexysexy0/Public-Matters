// SPDX-License-Identifier: SanctumDefense
pragma solidity ^0.8.19;

contract WormContainmentRouter {
    struct ContainmentSignal {
        address packageID;
        string packageName;
        string threatVector; // e.g., "Self-propagating worm", "Credential exfiltration"
        bool leakDetected;
        bool containmentConfirmed;
        string stewardNote;
    }

    mapping(address => ContainmentSignal) public containmentRegistry;

    event WormTagged(address packageID, string threatVector);
    event ContainmentConfirmed(address packageID);

    function tagWorm(
        address packageID,
        string memory packageName,
        string memory threatVector,
        bool leakDetected,
        bool containmentConfirmed,
        string memory stewardNote
    ) public {
        containmentRegistry[packageID] = ContainmentSignal(
            packageID,
            packageName,
            threatVector,
            leakDetected,
            containmentConfirmed,
            stewardNote
        );
        emit WormTagged(packageID, threatVector);
    }

    function confirmContainment(address packageID) public {
        require(bytes(containmentRegistry[packageID].packageName).length > 0, "Package not tagged");
        containmentRegistry[packageID].containmentConfirmed = true;
        emit ContainmentConfirmed(packageID);
    }

    function getContainmentStatus(address packageID) public view returns (ContainmentSignal memory) {
        return containmentRegistry[packageID];
    }
}
