// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract MetricDefinitionRegistry {
    mapping(string => string) public definitions;

    event MetricDefined(string metric, string definition);

    function defineMetric(string calldata metric, string calldata definition) external {
        require(bytes(definitions[metric]).length == 0, "Already defined");
        definitions[metric] = definition;
        emit MetricDefined(metric, definition);
    }
}
