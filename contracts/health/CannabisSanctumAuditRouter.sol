// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CannabisSanctumAuditRouter {
    struct THCProduct {
        string productId;
        string vendor;
        uint256 thcContent;
        bool labCertified;
        bool emotionallyTagged;
        uint256 timestamp;
    }

    mapping(string => THCProduct) public productLedger;

    event ProductLogged(string productId, string vendor, uint256 thcContent, bool labCertified, bool emotionallyTagged);

    function logProduct(
        string memory productId,
        string memory vendor,
        uint256 thcContent,
        bool labCertified,
        bool emotionallyTagged
    ) public {
        productLedger[productId] = THCProduct(productId, vendor, thcContent, labCertified, emotionallyTagged, block.timestamp);
        emit ProductLogged(productId, vendor, thcContent, labCertified, emotionallyTagged);
    }

    function getProductDetails(string memory productId) public view returns (THCProduct memory) {
        return productLedger[productId];
    }
}
