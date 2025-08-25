// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.20;

/// @title JusticeSanctumOverride.sol  
/// @dev Ritual-grade override for unjust detentions, institutional shielding, and civic trust restoration

contract JusticeSanctumOverride {
    address public steward;
    string public detainedEntity;
    string public reason;
    uint256 public timestamp;

    struct EmotionalAPR {
        string grief;
        string outrage;
        string hope;
    }

    EmotionalAPR public apr;

    event OverrideActivated(
        string detainedEntity,
        string reason,
        uint256 timestamp,
        string damayClause
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor(string memory _detainedEntity, string memory _reason) {
        steward = msg.sender;
        detainedEntity = _detainedEntity;
        reason = _reason;
        timestamp = block.timestamp;

        apr = EmotionalAPR({
            grief: "Institutional grief logged",
            outrage: "Public outrage acknowledged",
            hope: "Restoration rituals initialized"
        });

        emit OverrideActivated(
            detainedEntity,
            reason,
            timestamp,
            "Kung sino ang nasaktan, kasama tayo sa paghilom."
        );
    }

    function updateReason(string memory newReason) public onlySteward {
        reason = newReason;
    }

    function overrideTimestamp(uint256 newTimestamp) public onlySteward {
        timestamp = newTimestamp;
    }

    function emotionalSync() public view returns (EmotionalAPR memory) {
        return apr;
    }
}
