// SPDX-License-Identifier: TradeSanctum
pragma solidity ^0.8.19;

contract SafeTradeSanctifier {
    struct Product {
        string name;
        string originCountry;
        bool tariffSensitive;
        bool exempted;
        bool platformProtected;
    }

    mapping(bytes32 => Product) public products;

    event ProductTagged(string name, string originCountry);
    event TariffExempted(string name);
    event PlatformProtectionActivated(string name);

    function tagProduct(string memory name, string memory originCountry, bool tariffSensitive) public {
        bytes32 productId = keccak256(abi.encodePacked(name, originCountry));
        products[productId] = Product(name, originCountry, tariffSensitive, false, false);
        emit ProductTagged(name, originCountry);
    }

    function exemptTariff(string memory name, string memory originCountry) public {
        bytes32 productId = keccak256(abi.encodePacked(name, originCountry));
        products[productId].exempted = true;
        emit TariffExempted(name);
    }

    function protectPlatform(string memory name, string memory originCountry) public {
        bytes32 productId = keccak256(abi.encodePacked(name, originCountry));
        products[productId].platformProtected = true;
        emit PlatformProtectionActivated(name);
    }

    function getProductStatus(string memory name, string memory originCountry) public view returns (Product memory) {
        bytes32 productId = keccak256(abi.encodePacked(name, originCountry));
        return products[productId];
    }
}
