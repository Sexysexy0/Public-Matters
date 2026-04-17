// SovereignFiscalPolicy.sol
// Logic: Cutting VAT by 50% (From 12% to 6%)
pragma solidity ^0.8.0;

contract SovereignFiscalPolicy {
    uint256 public constant SOVEREIGN_VAT_RATE = 6; // Ang bagong 6% Standard
    uint256 public constant LEGACY_VAT_RATE = 12; // Ang lumang 12% System

    struct Transaction {
        uint256 netAmount;
        uint256 vatAmount;
        uint256 totalAmount;
    }

    function calculateSovereignPrice(uint256 _netPrice) public pure returns (uint256, uint256) {
        // Calculation: 6% VAT lang ang idadagdag
        uint256 vat = (_netPrice * SOVEREIGN_VAT_RATE) / 100;
        uint256 finalPrice = _netPrice + vat;
        
        return (vat, finalPrice);
    }

    function getSovereignSavings(uint256 _netPrice) public pure returns (uint256) {
        // Gaano kalaki ang natipid ng mamamayan vs Legacy 12%?
        uint256 legacyVat = (_netPrice * LEGACY_VAT_RATE) / 100;
        uint256 sovereignVat = (_netPrice * SOVEREIGN_VAT_RATE) / 100;
        
        return legacyVat - sovereignVat; // Ang perang nananatili sa bulsa ng tao
    }
}
