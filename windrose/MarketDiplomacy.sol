// [Goal: Uphold the safety and growth of rural settlements]
function updateSettlementTier(address _settlementID, bool _isSafe) external returns (string memory) {
    if (_isSafe) {
        // Status: Outpost upgraded. New tiles and paintings now available for collection.
        return "PROSPERITY: Plains territory is thriving under your protection.";
    }
    return "WARNING: Trade routes blocked by outlaws.";
}
