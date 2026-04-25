// [Goal: Add tactile feedback to critical hits and high-damage stats]
function applyImpactForce(uint256 _critChance, uint256 _baseDamage) external pure returns (uint256) {
    // Logic: Scale hit-stop duration based on damage magnitude
    if (_critChance > 20) return 150; // 150ms Hit-stop for maximum 'Oomph'
    return 100;
}
