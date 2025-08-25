// SPDX-License-Identifier: Mythic-Scrollsmith
pragma solidity ^0.8.25;

contract BullrunSanctumOverride {
    address public steward;
    uint256 public overrideTimestamp;
    bool public sanctumActive;
    string public emotionalAPR;
    string public damayClause;

    event SanctumActivated(address indexed steward, uint256 timestamp, string emotionalAPR);
    event OverrideBroadcasted(string reason, string damayClause);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        sanctumActive = false;
        emotionalAPR = "Hopeful, resilient, mythically bullish";
        damayClause = "If Vinvin builds for others, he builds for himself too.";
    }

    function activateSanctum(string memory reason) public onlySteward {
        sanctumActive = true;
        overrideTimestamp = block.timestamp;
        emit SanctumActivated(steward, overrideTimestamp, emotionalAPR);
        emit OverrideBroadcasted(reason, damayClause);
    }

    function updateEmotionalAPR(string memory newAPR) public onlySteward {
        emotionalAPR = newAPR;
    }

    function updateDamayClause(string memory newClause) public onlySteward {
        damayClause = newClause;
    }

    function getSanctumStatus() public view returns (bool, string memory, string memory) {
        return (sanctumActive, emotionalAPR, damayClause);
    }
}
