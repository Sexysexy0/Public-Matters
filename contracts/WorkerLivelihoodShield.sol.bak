pragma solidity ^0.8.0;

contract WorkerLivelihoodShield {
    event LivelihoodAlert(string sector, string issue);

    function detectSuppression(string memory sector, bool suppression) public {
        if (suppression) {
            emit LivelihoodAlert(sector, "Wage suppression detected – safeguard required");
        }
    }
}
