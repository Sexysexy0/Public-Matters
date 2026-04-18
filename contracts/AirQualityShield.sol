// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AirQualityShield {
    enum AirStatus { Healthy, Unhealthy, VeryUnhealthy, Acute }
    
    // [HEALTH GUARDRAIL] Alerting residents of Navotas Landfill Fire impact
    function getSafetyAdvice(AirStatus _status) public pure returns (string memory) {
        if (_status == AirStatus.VeryUnhealthy) {
            return "ALERT: Stay indoors. Postpone unnecessary trips. Wear N95 masks.";
        }
        return "Proceed with caution.";
    }
}
