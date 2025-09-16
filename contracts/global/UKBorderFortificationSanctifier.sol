// SPDX-License-Identifier: BorderSanctum
pragma solidity ^0.8.19;

contract UKBorderFortificationSanctifier {
    struct BorderSignal {
        string zone;
        string policyCode;
        bool fortified;
        string stewardNote;
    }

    mapping(string => BorderSignal) public borderRegistry;

    event BorderTagged(string zone, string policyCode);
    event BorderFortified(string zone);

    function tagBorder(string memory zone, string memory policyCode, string memory stewardNote) public {
        borderRegistry[zone] = BorderSignal(zone, policyCode, false, stewardNote);
        emit BorderTagged(zone, policyCode);
    }

    function fortifyBorder(string memory zone) public {
        require(bytes(borderRegistry[zone].policyCode).length > 0, "Border not tagged");
        borderRegistry[zone].fortified = true;
        emit BorderFortified(zone);
    }

    function getBorderStatus(string memory zone) public view returns (BorderSignal memory) {
        return borderRegistry[zone];
    }
}
