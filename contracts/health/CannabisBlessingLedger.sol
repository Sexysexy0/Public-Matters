// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CannabisBlessingLedger {
    enum BlessingType { Relief, Restoration, Resonance }

    struct CannabisProduct {
        string productId;
        string vendor;
        BlessingType blessing;
        bool labCertified;
        bool emotionallyTagged;
        bool validatorApproved;
        uint256 timestamp;
    }

    mapping(string => CannabisProduct) public productLedger;

    event ProductBlessed(
        string productId,
        string vendor,
        BlessingType blessing,
        bool labCertified,
        bool emotionallyTagged,
        bool validatorApproved
    );

    function blessProduct(
        string memory productId,
        string memory vendor,
        BlessingType blessing,
        bool labCertified,
        bool emotionallyTagged,
        bool validatorApproved
    ) public {
        productLedger[productId] = CannabisProduct(
            productId,
            vendor,
            blessing,
            labCertified,
            emotionallyTagged,
            validatorApproved,
            block.timestamp
        );

        emit ProductBlessed(
            productId,
            vendor,
            blessing,
            labCertified,
            emotionallyTagged,
            validatorApproved
        );
    }

    function getProductDetails(string memory productId) public view returns (CannabisProduct memory) {
        return productLedger[productId];
    }
}
