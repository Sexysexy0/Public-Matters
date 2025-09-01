// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PermitFeeRegistry {
    struct PermitTier {
        string category;
        uint256 baseFee;
        uint256 empathyDiscount;
        uint256 clarityPenalty;
        bool active;
    }

    mapping(string => PermitTier) public permits;
    string[] public categories;

    event PermitFeeUpdated(
        string category,
        uint256 baseFee,
        uint256 empathyDiscount,
        uint256 clarityPenalty
    );

    function setPermitFee(
        string memory _category,
        uint256 _baseFee,
        uint256 _empathyDiscount,
        uint256 _clarityPenalty
    ) public {
        permits[_category] = PermitTier(_category, _baseFee, _empathyDiscount, _clarityPenalty, true);
        categories.push(_category);
        emit PermitFeeUpdated(_category, _baseFee, _empathyDiscount, _clarityPenalty);
    }

    function getPermitFee(string memory _category) public view returns (PermitTier memory) {
        return permits[_category];
    }

    function listPermitCategories() public view returns (string[] memory) {
        return categories;
    }
}
