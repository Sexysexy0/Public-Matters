// PetroleumReserveAccountability.sol
pragma solidity ^0.8.0;

contract PetroleumReserveAccountability {
    struct ReserveStatus {
        uint256 currentLiters;
        uint256 minimumRequirement;
        uint256 lastRestockDate;
    }

    ReserveStatus public spr;

    event LowReserveAlert(uint256 current, uint256 threshold);

    function updateInventory(uint256 _liters) public {
        spr.currentLiters = _liters;
        spr.lastRestockDate = block.timestamp;
        
        if (spr.currentLiters < spr.minimumRequirement) {
            emit LowReserveAlert(spr.currentLiters, spr.minimumRequirement);
        }
    }
}
