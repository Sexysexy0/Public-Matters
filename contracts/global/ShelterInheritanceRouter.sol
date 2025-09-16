// SPDX-License-Identifier: ShelterSanctum
pragma solidity ^0.8.19;

contract ShelterInheritanceRouter {
    struct InheritanceSignal {
        address steward;
        string shelterID;
        string heirName;
        uint256 transferDate;
        bool dignityCertified;
        bool verified;
        string stewardNote;
    }

    mapping(string => InheritanceSignal) public inheritanceRegistry;

    event InheritanceTagged(string shelterID, string heirName);
    event InheritanceVerified(string shelterID);

    function tagInheritance(string memory shelterID, address steward, string memory heirName, uint256 transferDate, bool dignityCertified, string memory stewardNote) public {
        inheritanceRegistry[shelterID] = InheritanceSignal(steward, shelterID, heirName, transferDate, dignityCertified, false, stewardNote);
        emit InheritanceTagged(shelterID, heirName);
    }

    function verifyInheritance(string memory shelterID) public {
        require(bytes(inheritanceRegistry[shelterID].heirName).length > 0, "Inheritance not tagged");
        inheritanceRegistry[shelterID].verified = true;
        emit InheritanceVerified(shelterID);
    }

    function getInheritanceStatus(string memory shelterID) public view returns (InheritanceSignal memory) {
        return inheritanceRegistry[shelterID];
    }
}
