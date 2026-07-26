// DirectFarmToMarket.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DirectFarmToMarket is Ownable {

    constructor() Ownable(msg.sender) {}

    struct CropBatch {
        address farmer;
        uint256 priceFloor; // Minimum price set by the farmer
        bool isSold;
    }

    function buyProduce(uint256 _batchId) public payable {
        // Automatically bypasses predatory traders
        // 95% goes to farmer, 5% to local logistics cooperative
        (bool success, ) = payable(crops[_batchId].farmer).call{value: msg.value * 95 / 100}(""); require(success, "Transfer failed");
    }
}
