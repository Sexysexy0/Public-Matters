// PublicOfficialAudit.sol
pragma solidity ^0.8.0;

contract PublicOfficialAudit {
    struct Official {
        uint256 reportedIncome;
        uint256 totalAssetValue;
        bool underInvestigation;
    }

    mapping(address => Official) public stateOfficials;

    function flagDiscrepancy(address _official, uint256 _newAssetValue) public {
        uint256 threshold = stateOfficials[_official].reportedIncome * 10; // Halimbawa: 10x ng sahod
        if (_newAssetValue > threshold) {
            stateOfficials[_official].underInvestigation = true;
        }
    }
}
