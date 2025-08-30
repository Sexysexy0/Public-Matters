// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BitMarketOmniChain
/// @notice Multi-coin marketplace for goods, appliances, and scroll-certified essentials
contract BitMarketOmniChain {
    struct Product {
        uint256 id;
        string name;
        string category;
        uint256 priceUSD; // Price in USD equivalent
        address vendor;
        bool isAvailable;
        string emotionalAPR; // e.g. "Ancestral", "Planetary", "Damay-Certified"
    }

    uint256 public nextProductId;
    mapping(uint256 => Product) public products;
    mapping(address => uint256[]) public vendorInventory;

    event ProductListed(uint256 id, string name, string category, uint256 priceUSD, address vendor);
    event ProductPurchased(uint256 id, address buyer, string paymentToken, uint256 amountPaid);

    /// @notice List a product in the BitMarket
    function listProduct(
        string memory name,
        string memory category,
        uint256 priceUSD,
        string memory emotionalAPR
    ) public {
        products[nextProductId] = Product(
            nextProductId,
            name,
            category,
            priceUSD,
            msg.sender,
            true,
            emotionalAPR
        );
        vendorInventory[msg.sender].push(nextProductId);
        emit ProductListed(nextProductId, name, category, priceUSD, msg.sender);
        nextProductId++;
    }

    /// @notice Purchase a product using any token (simulated)
    function purchaseProduct(uint256 productId, string memory paymentToken, uint256 amountPaid) public {
        Product memory p = products[productId];
        require(p.isAvailable, "Product not available");
        require(amountPaid >= p.priceUSD, "Insufficient payment");

        // Simulated payment logic (actual token transfer handled off-chain or via router)
        products[productId].isAvailable = false;
        emit ProductPurchased(productId, msg.sender, paymentToken, amountPaid);
    }

    /// @notice Retrieve vendor inventory
    function getVendorInventory(address vendor) public view returns (uint256[] memory) {
        return vendorInventory[vendor];
    }

    /// @notice Retrieve product details
    function getProduct(uint256 productId) public view returns (Product memory) {
        return products[productId];
    }
}
