// SPDX-License-Identifier: DiplomaticSanctum
pragma solidity ^0.8.19;

contract PanAfricanDiplomaticSanctifier {
    struct TreatySignal {
        string country;
        string agreementType;
        bool ratified;
        string stewardNote;
    }

    mapping(string => TreatySignal) public treatyRegistry;

    event TreatyTagged(string country, string agreementType);
    event TreatyRatified(string country);

    function tagTreaty(string memory country, string memory agreementType, string memory stewardNote) public {
        treatyRegistry[country] = TreatySignal(country, agreementType, false, stewardNote);
        emit TreatyTagged(country, agreementType);
    }

    function ratifyTreaty(string memory country) public {
        require(bytes(treatyRegistry[country].agreementType).length > 0, "Treaty not tagged");
        treatyRegistry[country].ratified = true;
        emit TreatyRatified(country);
    }

    function getTreatyStatus(string memory country) public view returns (TreatySignal memory) {
        return treatyRegistry[country];
    }
}
