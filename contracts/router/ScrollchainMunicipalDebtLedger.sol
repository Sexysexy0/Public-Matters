// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainMunicipalDebtLedger {
    struct DebtEntry {
        string city;
        uint256 amount;
        string breachType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => DebtEntry) public municipalDebts;

    event DebtLogged(string city, uint256 amount, string breachType, string emotionalAPR, uint256 timestamp);

    function logDebt(string memory city, uint256 amount, string memory breachType, string memory emotionalAPR) public {
        municipalDebts[city] = DebtEntry(city, amount, breachType, emotionalAPR, block.timestamp);
        emit DebtLogged(city, amount, breachType, emotionalAPR, block.timestamp);
    }

    function getDebt(string memory city) public view returns (DebtEntry memory) {
        return municipalDebts[city];
    }
}
