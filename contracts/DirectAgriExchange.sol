// DirectAgriExchange.sol
pragma solidity ^0.8.0;

contract DirectAgriExchange {
    struct CropBatch {
        string cropType;
        uint256 pricePerUnit;
        address farmerAddress;
        bool sold;
    }

    CropBatch[] public marketplace;

    function listCrop(string memory _type, uint256 _price) public {
        marketplace.push(CropBatch(_type, _price, msg.sender, false));
    }

    function purchaseDirect(uint256 _batchId) public payable {
        require(!marketplace[_batchId].sold, "Already sold");
        marketplace[_batchId].sold = true;
        payable(marketplace[_batchId].farmerAddress).transfer(msg.value);
    }
}
