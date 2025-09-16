// SPDX-License-Identifier: CustomsSanctum
pragma solidity ^0.8.19;

contract CustomsEquityBlessingRouter {
    struct CustomsSignal {
        string portName;
        string country;
        bool blessed;
        string stewardNote;
    }

    mapping(string => CustomsSignal) public customsRegistry;

    event CustomsTagged(string portName, string country);
    event CustomsBlessed(string portName);

    function tagCustoms(string memory portName, string memory country, string memory stewardNote) public {
        customsRegistry[portName] = CustomsSignal(portName, country, false, stewardNote);
        emit CustomsTagged(portName, country);
    }

    function blessCustoms(string memory portName) public {
        require(bytes(customsRegistry[portName].country).length > 0, "Customs not tagged");
        customsRegistry[portName].blessed = true;
        emit CustomsBlessed(portName);
    }

    function getCustomsStatus(string memory portName) public view returns (CustomsSignal memory) {
        return customsRegistry[portName];
    }
}
