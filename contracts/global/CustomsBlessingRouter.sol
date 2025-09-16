// SPDX-License-Identifier: CustomsSanctum
pragma solidity ^0.8.19;

contract CustomsBlessingRouter {
    struct CustomsSignal {
        string borderName;
        string partnerCountry;
        bool blessed;
        string stewardNote;
    }

    mapping(string => CustomsSignal) public customsRegistry;

    event CustomsTagged(string borderName, string partnerCountry);
    event CustomsBlessed(string borderName);

    function tagCustoms(string memory borderName, string memory partnerCountry, string memory stewardNote) public {
        customsRegistry[borderName] = CustomsSignal(borderName, partnerCountry, false, stewardNote);
        emit CustomsTagged(borderName, partnerCountry);
    }

    function blessCustoms(string memory borderName) public {
        require(bytes(customsRegistry[borderName].partnerCountry).length > 0, "Customs not tagged");
        customsRegistry[borderName].blessed = true;
        emit CustomsBlessed(borderName);
    }

    function getCustomsStatus(string memory borderName) public view returns (CustomsSignal memory) {
        return customsRegistry[borderName];
    }
}
