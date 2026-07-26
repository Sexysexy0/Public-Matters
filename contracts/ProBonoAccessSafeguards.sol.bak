// ProBonoAccessSafeguards.sol
pragma solidity ^0.8.0;

contract ProBonoAccessSafeguards {
    struct LegalFirm {
        uint256 proBonoHours;
        uint256 justiceCredits;
        bool isCompliant;
    }

    mapping(address => LegalFirm) public firms;

    function logProBonoWork(address _firm, uint256 _hours) public {
        firms[_firm].proBonoHours += _hours;
        
        // Reward logic: 1 credit per 10 pro-bono hours
        if (_hours >= 10) {
            firms[_firm].justiceCredits += (_hours / 10);
            firms[_firm].isCompliant = true;
        }
    }
}
