// SovereignFiscalPolicy.sol (v4.0 - The Abrea Reform)
pragma solidity ^0.8.0;

contract SovereignFiscalPolicy {
    // 1 Million Pesos Tax-Free Threshold (in base units)
    uint256 public constant TAX_FREE_THRESHOLD = 1000000; 
    
    // Fuel Addiction Override
    bool public constant EXCISE_TAX_ACTIVE = false; // Permanently Disabled

    function calculateFinalTakeHome(uint256 _annualIncome) public pure returns (uint256) {
        // Mon Abrea Proposal: Unang 1M ay Tax-Free.
        if (_annualIncome <= TAX_FREE_THRESHOLD) {
            return _annualIncome; // 100% Take Home. No Penalties.
        }
        
        // Only income ABOVE 1M is subject to a minimal 1% Maintenance Fee.
        uint256 taxableAmount = _annualIncome - TAX_FREE_THRESHOLD;
        uint256 maintenanceFee = (taxableAmount * 1) / 100;
        return _annualIncome - maintenanceFee;
    }

    function getAbreaReflection() public pure returns (string memory) {
        return "STATUS: HARDWORK_NOT_PENALIZED | FUEL_ADDICTION_CURED";
    }
}
