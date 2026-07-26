// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FuelQualityOracle {
    struct FuelBatch {
        uint256 octaneLevel;
        uint256 impurityScore; // Dapat mababa ito para hindi masira ang makina
        bool isSafeForEngine;
    }

    mapping(uint256 => FuelBatch) public qualityRegistry;

    function certifyFuel(uint256 _batchId, uint256 _octane, uint256 _impurities) public {
        bool safe = (_octane >= 91 && _impurities < 5); // Example standard
        qualityRegistry[_batchId] = FuelBatch(_octane, _impurities, safe);
    }
}
