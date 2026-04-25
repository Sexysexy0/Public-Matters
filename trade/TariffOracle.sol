// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TariffOracle {
    uint256 public constant ANTI_DUMPING_TARIFF = 157; // 157%

    function calculateFinalCost(uint256 _declaredValue, bool _isCCPLinked) external pure returns (uint256) {
        if (_isCCPLinked) {
            return (_declaredValue * (100 + ANTI_DUMPING_TARIFF)) / 100;
        }
        return _declaredValue;
    }
}
