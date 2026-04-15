pragma solidity ^0.8.0;

contract TransparencyMetrics {
    event TransparencyReport(string game, uint256 fps, uint256 crashRate);

    function logMetrics(string memory game, uint256 fps, uint256 crashRate) public {
        emit TransparencyReport(game, fps, crashRate);
    }
}
