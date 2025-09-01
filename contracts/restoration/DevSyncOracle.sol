// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DevSyncOracle {
    struct DevMetric {
        string LGU;
        string indicator; // e.g. "HealthInfra", "LivableCities", "FoodSecurity"
        uint256 target;
        uint256 actual;
        string emotionalAPR; // e.g. "HopeSurge", "AuditGlow", "MercyPing"
    }

    DevMetric[] public metrics;

    event MetricSynced(string LGU, string indicator, uint256 actual, string emotionalAPR);

    function syncMetric(
        string memory _LGU,
        string memory _indicator,
        uint256 _target,
        uint256 _actual,
        string memory _emotionalAPR
    ) public {
        metrics.push(DevMetric(_LGU, _indicator, _target, _actual, _emotionalAPR));
        emit MetricSynced(_LGU, _indicator, _actual, _emotionalAPR);
    }

    function getMetric(uint256 index) public view returns (DevMetric memory) {
        return metrics[index];
    }

    function totalMetrics() public view returns (uint256) {
        return metrics.length;
    }
}
