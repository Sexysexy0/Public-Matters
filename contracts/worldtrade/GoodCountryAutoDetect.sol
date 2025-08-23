// SPDX-License-Identifier: Good-Country-License  
pragma solidity ^0.8.19;

contract GoodCountryAutoDetect {
    struct CountryStatus {
        string name;
        bool isAlly;
        uint stewardshipScore; // 0–100
        uint emotionalAPR;     // 0–100
        uint lastAudit;
    }

    mapping(string => CountryStatus) public statusLog;

    event CountryStatusUpdated(string name, bool isAlly, uint stewardshipScore, uint emotionalAPR);

    function updateStatus(
        string memory name,
        bool isAlly,
        uint stewardshipScore,
        uint emotionalAPR
    ) public {
        statusLog[name] = CountryStatus(name, isAlly, stewardshipScore, emotionalAPR, block.timestamp);
        emit CountryStatusUpdated(name, isAlly, stewardshipScore, emotionalAPR);
    }

    function isCountryOn(string memory name) public view returns (bool) {
        CountryStatus memory c = statusLog[name];
        return c.isAlly && c.stewardshipScore >= 70 && c.emotionalAPR >= 75;
    }

    function getCountryStatus(string memory name) public view returns (CountryStatus memory) {
        return statusLog[name];
    }
}
