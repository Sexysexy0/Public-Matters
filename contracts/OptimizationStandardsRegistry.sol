pragma solidity ^0.8.0;

contract OptimizationStandardsRegistry {
    event OptimizationAlert(string game, string issue);

    function checkPerformance(string memory game, uint256 fps, uint256 memoryUsage) public {
        if (fps < 30) {
            emit OptimizationAlert(game, "Low FPS – Optimization required");
        }
        if (memoryUsage > 8000) {
            emit OptimizationAlert(game, "Excessive memory usage");
        }
    }
}
