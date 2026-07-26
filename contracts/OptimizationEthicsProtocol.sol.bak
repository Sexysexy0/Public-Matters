pragma solidity ^0.8.0;

contract OptimizationEthicsProtocol {
    event EthicsAlert(string game, string issue);

    function checkGame(string memory game, uint256 fps, uint256 crashRate) public {
        if (fps < 30) {
            emit EthicsAlert(game, "Low FPS – violates optimization ethics");
        }
        if (crashRate > 5) {
            emit EthicsAlert(game, "High crash rate – violates optimization ethics");
        }
    }
}
