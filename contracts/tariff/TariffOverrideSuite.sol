// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffOverrideSuite {
    address public steward;
    mapping(string => uint256) public importTariff;
    mapping(string => uint256) public exportTariff;

    event TariffUpdated(string region, string type, uint256 newRate);

    constructor() {
        steward = msg.sender;
        importTariff["China"] = 9999; // Blocked via extreme tariff
        exportTariff["China"] = 9999;
        importTariff["Russia"] = 9999;
        exportTariff["Russia"] = 9999;
        importTariff["India"] = 0;
        exportTariff["India"] = 0;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function setImportTariff(string memory region, uint256 rate) public onlySteward {
        importTariff[region] = rate;
        emit TariffUpdated(region, "Import", rate);
    }

    function setExportTariff(string memory region, uint256 rate) public onlySteward {
        exportTariff[region] = rate;
        emit TariffUpdated(region, "Export", rate);
    }

    function getImportTariff(string memory region) public view returns (uint256) {
        return importTariff[region];
    }

    function getExportTariff(string memory region) public view returns (uint256) {
        return exportTariff[region];
    }
}
