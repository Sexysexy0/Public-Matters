// SPDX-License-Identifier: FXPulseOverride-License
pragma solidity ^0.8.0;

contract FXPulseOverrideRouter {
    address public steward;

    struct PulseOverride {
        string originPair;
        string reroutedPair;
        bool overrideConfirmed;
        string blessingType;
        uint256 timestamp;
    }

    PulseOverride[] public overrides;

    event FXPulseOverridden(string originPair, string reroutedPair, bool overrideConfirmed, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function overridePulse(string memory originPair, string memory reroutedPair, bool overrideConfirmed, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can override");
        overrides.push(PulseOverride(originPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp));
        emit FXPulseOverridden(originPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp);
    }

    function getOverride(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PulseOverride memory o = overrides[index];
        return (o.originPair, o.reroutedPair, o.overrideConfirmed, o.blessingType, o.timestamp);
    }
}
