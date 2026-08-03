// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignHarvestProtocol {
    address public immutable rootAdmin;

    struct CropBatch {
        address farmer;
        string cropType;
        uint256 quantityKg;
        uint256 pricePerKg;
        bool isSold;
    }

    mapping(uint256 => CropBatch) public cropListings;
    uint256 public batchCount;

    event CropListed(uint256 batchId, address farmer, string cropType, uint256 quantityKg, uint256 pricePerKg);
    event CropPurchased(uint256 batchId, address buyer, uint256 totalPaid);

    constructor() {
        rootAdmin = msg.sender;
    }

    function listCrop(string memory _cropType, uint256 _quantityKg, uint256 _pricePerKg) external {
        require(_quantityKg > 0 && _pricePerKg > 0, "Invalid parameters");
        cropListings[batchCount] = CropBatch({
            farmer: msg.sender,
            cropType: _cropType,
            quantityKg: _quantityKg,
            pricePerKg: _pricePerKg,
            isSold: false
        });
        emit CropListed(batchCount, msg.sender, _cropType, _quantityKg, _pricePerKg);
        batchCount++;
    }

    function buyCropDirect(uint256 _batchId) external payable {
        CropBatch storage batch = cropListings[_batchId];
        require(!batch.isSold, "Crop already sold");
        
        uint256 totalCost = batch.quantityKg * batch.pricePerKg;
        require(msg.value >= totalCost, "Insufficient payment");

        batch.isSold = true;

        // Direct payment to farmer (No Middlemen/Cartel allowed!)
        (bool success, ) = batch.farmer.call{value: totalCost}("");
        require(success, "Payment to farmer failed");

        // Refund excess if the buyer paid more than exact cost
        if (msg.value > totalCost) {
            (bool refundSuccess, ) = msg.sender.call{value: msg.value - totalCost}("");
            require(refundSuccess, "Refund failed");
        }

        emit CropPurchased(_batchId, msg.sender, totalCost);
    }
}
