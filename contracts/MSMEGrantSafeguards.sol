// MSMEGrantSafeguards.sol
pragma solidity ^0.8.0;

contract MSMEGrantSafeguards {
    struct GrantCondition {
        uint256 businessId;
        bool usesLocalMaterials;
        bool maintainsFairPrice;
        uint256 complianceScore;
    }

    mapping(uint256 => GrantCondition) public grants;

    function verifyAndRelease(uint256 _id, bool _local, bool _fair) public {
        uint256 score = 0;
        if (_local) score += 50;
        if (_fair) score += 50;
        
        grants[_id] = GrantCondition(_id, _local, _fair, score);
        
        // Only businesses with 100 score can claim the full grant
        if (score == 100) {
            // Trigger grant disbursement logic here
        }
    }
}
