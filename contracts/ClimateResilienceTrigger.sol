pragma solidity ^0.8.0;

contract ClimateResilienceTrigger {
    event Alert(string hazard, string action);

    function checkHazard(uint256 temp, uint256 rainfall) public {
        if (temp > 36) {
            emit Alert("Heatwave", "Deploy canopy & cooling stations");
        }
        if (rainfall > 200) {
            emit Alert("Flood", "Activate drainage & relief protocols");
        }
    }
}
