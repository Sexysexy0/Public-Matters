// AgriResilienceIncentive.sol
// Logic: Rewarding Local Food Independence
pragma solidity ^0.8.0;

contract AgriResilienceIncentive {
    function grantIncentive(bool _isOrganic, bool _isLocal) public pure returns (uint256) {
        if (_isOrganic && _isLocal) {
            return 500; // Sovereign Credits for Food Security
        }
        return 0;
    }
}
