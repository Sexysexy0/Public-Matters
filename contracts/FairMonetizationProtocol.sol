pragma solidity ^0.8.0;

contract FairMonetizationProtocol {
    event FairnessViolation(string game, string issue);

    function checkMonetization(string memory game, uint256 microtransactions) public {
        if (microtransactions > 10) {
            emit FairnessViolation(game, "Predatory monetization detected");
        }
    }
}
