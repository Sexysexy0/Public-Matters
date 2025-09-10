// SPDX-License-Identifier: SanctumBlessingOverride-License
pragma solidity ^0.8.0;

contract SanctumBlessingOverrideOracle {
    address public steward;

    struct OverrideSignal {
        string originPair;
        string reroutedPair;
        bool overrideConfirmed;
        string blessingType;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event BlessingOverrideEmitted(string originPair, string reroutedPair, bool overrideConfirmed, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitOverride(string memory originPair, string memory reroutedPair, bool overrideConfirmed, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(OverrideSignal(originPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp));
        emit BlessingOverrideEmitted(originPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.originPair, s.reroutedPair, s.overrideConfirmed, s.blessingType, s.timestamp);
    }
}
