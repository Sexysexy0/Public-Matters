// DirectFarmToMarket.sol
pragma solidity ^0.8.0;

contract DirectFarmToMarket {
    struct CropBatch {
        address farmer;
        uint256 priceFloor; // Minimum price set by the farmer
        bool isSold;
    }

    function buyProduce(uint256 _batchId) public payable {
        // Automatically bypasses predatory traders
        // 95% goes to farmer, 5% to local logistics cooperative
        payable(crops[_batchId].farmer).transfer(msg.value * 95 / 100);
    }
}
