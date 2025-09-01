// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DeficitBlessingProtocol {
    struct TradePartner {
        string country;
        uint256 importVolume;
        uint256 exportVolume;
        int256 tradeBalance;
        bool blessed;
    }

    mapping(string => TradePartner) public partners;
    string[] public blessedPartners;

    event PartnerBlessed(string country, int256 tradeBalance);
    event ExportSurge(string country, uint256 newExportVolume);

    function blessPartner(
        string memory _country,
        uint256 _importVolume,
        uint256 _exportVolume
    ) public {
        int256 balance = int256(_exportVolume) - int256(_importVolume);
        partners[_country] = TradePartner(_country, _importVolume, _exportVolume, balance, true);
        blessedPartners.push(_country);
        emit PartnerBlessed(_country, balance);
    }

    function updateExportVolume(string memory _country, uint256 _newExportVolume) public {
        require(partners[_country].blessed, "Partner not blessed yet");
        partners[_country].exportVolume = _newExportVolume;
        partners[_country].tradeBalance = int256(_newExportVolume) - int256(partners[_country].importVolume);
        emit ExportSurge(_country, _newExportVolume);
    }

    function getBlessedPartners() public view returns (string[] memory) {
        return blessedPartners;
    }

    function getTradeBalance(string memory _country) public view returns (int256) {
        return partners[_country].tradeBalance;
    }
}
