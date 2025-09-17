// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract TariffNegotiationRouter {
    struct TariffSignal {
        address countryID;
        string countryName;
        uint256 tariffRate;
        string negotiationStatus; // e.g., "Pending", "In Progress", "Resolved"
        bool clauseTriggered;
        string stewardNote;
    }

    mapping(address => TariffSignal) public tariffRegistry;

    event TariffTagged(address countryID, uint256 tariffRate);
    event NegotiationUpdated(address countryID, string negotiationStatus);

    function tagTariff(address countryID, string memory countryName, uint256 tariffRate, string memory negotiationStatus, bool clauseTriggered, string memory stewardNote) public {
        tariffRegistry[countryID] = TariffSignal(countryID, countryName, tariffRate, negotiationStatus, clauseTriggered, stewardNote);
        emit TariffTagged(countryID, tariffRate);
    }

    function updateNegotiation(address countryID, string memory negotiationStatus) public {
        require(bytes(tariffRegistry[countryID].countryName).length > 0, "Country not tagged");
        tariffRegistry[countryID].negotiationStatus = negotiationStatus;
        emit NegotiationUpdated(countryID, negotiationStatus);
    }

    function getTariffStatus(address countryID) public view returns (TariffSignal memory) {
        return tariffRegistry[countryID];
    }
}
