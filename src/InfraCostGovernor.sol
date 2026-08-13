// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract InfraCostGovernor {
    struct InfraRecord {
        uint256 bareMetalCost;
        uint256 cloudCost;
    }

    mapping(bytes32 => InfraRecord) public records;

    event InfraLogged(bytes32 indexed workload, uint256 bareMetalCost, uint256 cloudCost);
    event MarkupFlagged(bytes32 indexed workload, uint256 markupPercent);

    function logInfra(bytes32 workload, uint256 bareMetalCost, uint256 cloudCost) external {
        records[workload] = InfraRecord(bareMetalCost, cloudCost);
        emit InfraLogged(workload, bareMetalCost, cloudCost);

        if (cloudCost > bareMetalCost * 150 / 100) {
            emit MarkupFlagged(workload, (cloudCost * 100) / bareMetalCost);
        }
    }
}
