// OpenSourceMedLedger.sol
pragma solidity ^0.8.0;

contract OpenSourceMedLedger {
    struct Formula {
        string drugName;
        string manufacturingSteps;
        bool isEssential;
    }

    mapping(uint256 => Formula) public globalMeds;

    function publishFormula(uint256 _id, string memory _name, string memory _steps) public {
        // Ensures essential medicine is never hidden behind a 1,000% markup
        globalMeds[_id] = Formula(_name, _steps, true);
    }
}
