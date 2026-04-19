// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DynamicPowertrainManager {
    enum MotorState { Single, Dual, Triple }

    // [9:57-10:44] Optimizing motor usage based on torque and speed requirements
    function allocatePower(uint256 _loadWeight, uint256 _inclineGrade) public pure returns (MotorState) {
        if (_loadWeight > 40000 || _inclineGrade > 5) {
            // Maximum torque needed for heavy loads or steep hills
            return MotorState.Triple;
        }
        if (_loadWeight < 10000 && _inclineGrade == 0) {
            // Cruising at high efficiency
            return MotorState.Single;
        }
        return MotorState.Dual;
    }
}
