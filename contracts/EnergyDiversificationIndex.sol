pragma solidity ^0.8.0;

contract EnergyDiversificationIndex {
    event DiversifyAlert(uint256 oilShare, string action);

    function checkMix(uint256 oilShare) public {
        if (oilShare > 70) {
            emit DiversifyAlert(oilShare, "Invest in renewables & local energy");
        }
    }
}
