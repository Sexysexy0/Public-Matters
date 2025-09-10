// SPDX-License-Identifier: WhistleblowerProtectionBlessing-License
pragma solidity ^0.8.0;

contract WhistleblowerProtectionBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string institution;
        string whistleblowerName;
        string threatLevel;
        bool protectionGranted;
        bool restorationConfirmed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event WhistleblowerBlessingRouted(string institution, string whistleblowerName, string threatLevel, bool protectionGranted, bool restorationConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory institution, string memory whistleblowerName, string memory threatLevel, bool protectionGranted, bool restorationConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(institution, whistleblowerName, threatLevel, protectionGranted, restorationConfirmed, block.timestamp));
        emit WhistleblowerBlessingRouted(institution, whistleblowerName, threatLevel, protectionGranted, restorationConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.institution, s.whistleblowerName, s.threatLevel, s.protectionGranted, s.restorationConfirmed, s.timestamp);
    }
}
