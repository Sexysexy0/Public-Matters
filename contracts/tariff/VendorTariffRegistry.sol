// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VendorTariffRegistry {
    struct TariffProfile {
        string category;
        uint256 baseRate;
        uint256 empathyBoost;
        uint256 clarityPenalty;
        bool active;
    }

    mapping(string => TariffProfile) public tariffs;
    string[] public categories;

    event TariffUpdated(string category, uint256 baseRate, uint256 empathyBoost, uint256 clarityPenalty);

    function setTariff(
        string memory _category,
        uint256 _baseRate,
        uint256 _empathyBoost,
        uint256 _clarityPenalty
    ) public {
        tariffs[_category] = TariffProfile(_category, _baseRate, _empathyBoost, _clarityPenalty, true);
        categories.push(_category);
        emit TariffUpdated(_category, _baseRate, _empathyBoost, _clarityPenalty);
    }

    function getTariff(string memory _category) public view returns (TariffProfile memory) {
        return tariffs[_category];
    }

    function listCategories() public view returns (string[] memory) {
        return categories;
    }
}
