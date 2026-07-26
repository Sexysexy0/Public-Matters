// ExportMarginAudit.sol
// Logic: Prioritizing the Local Table
pragma solidity ^0.8.0;

contract ExportMarginAudit {
    function calculatePriority(uint256 _exportProfit, uint256 _domesticNeed) public pure returns (string memory) {
        // If domestic supply is in the "Danger Zone", increase export tax.
        if (_domesticNeed < 20) {
            return "ACTION_REQUIRED: APPLY_EXPORT_TARIFF_TO_SECURE_LOCAL_SUPPLY";
        }
        return "EXPORT_PERMITTED";
    }
}
