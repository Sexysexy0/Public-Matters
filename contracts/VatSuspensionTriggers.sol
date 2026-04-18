// VatSuspensionTriggers.sol
pragma solidity ^0.8.0;

contract VatSuspensionTriggers {
    uint256 public constant PAIN_THRESHOLD = 140; // Presyo sa kanto (PHP)

    function checkPriceAndSuspension(uint256 _currentPrice) public pure returns (string memory) {
        if (_currentPrice >= PAIN_THRESHOLD) {
            return "VAT SUSPENDED: Immediate 12% relief activated for consumers.";
        }
        return "TAX ACTIVE: Prices within normal operational range.";
    }
}
