// SPDX-License-Identifier: TariffSanctum
pragma solidity ^0.8.19;

contract TariffReliefRouter {
    struct TariffSignal {
        string sector;
        string reliefType; // e.g., "Suspension", "Reduction", "Exemption"
        uint256 estimatedSavings;
        string jurisdiction;
        bool verified;
        string stewardNote;
    }

    mapping(string => TariffSignal) public tariffRegistry;

    event TariffTagged(string sector, string reliefType);
    event ReliefVerified(string sector);

    function tagTariff(string memory sector, string memory reliefType, uint256 estimatedSavings, string memory jurisdiction, string memory stewardNote) public {
        tariffRegistry[sector] = TariffSignal(sector, reliefType, estimatedSavings, jurisdiction, false, stewardNote);
        emit TariffTagged(sector, reliefType);
    }

    function verifyRelief(string memory sector) public {
        require(bytes(tariffRegistry[sector].reliefType).length > 0, "Tariff not tagged");
        tariffRegistry[sector].verified = true;
        emit ReliefVerified(sector);
    }

    function getTariffStatus(string memory sector) public view returns (TariffSignal memory) {
        return tariffRegistry[sector];
    }
}
