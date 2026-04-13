// CarbonOffsetAccountability.sol
pragma solidity ^0.8.0;

contract CarbonOffsetAccountability {
    struct EmissionRecord {
        uint256 lastReading;
        uint256 reductionTotal;
        uint256 equityTokensEarned;
    }

    mapping(address => EmissionRecord) public tracking;

    function logReduction(address _unit, uint256 _currentEmission) public {
        EmissionRecord storage record = tracking[_unit];
        
        if (_currentEmission < record.lastReading) {
            uint256 saved = record.lastReading - _currentEmission;
            record.reductionTotal += saved;
            record.equityTokensEarned += (saved / 10); // 1 token per 10 units reduced
        }
        record.lastReading = _currentEmission;
    }
}
