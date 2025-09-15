// SPDX-License-Identifier: FreezeSanctum
pragma solidity ^0.8.19;

contract LiquidationFreezeRouter {
    struct FreezeSignal {
        address protocol;
        uint256 riskRatio; // liability / borrow limit
        bool freezeActivated;
        string stewardNote;
    }

    mapping(address => FreezeSignal) public freezeSignals;

    event FreezeTagged(address protocol, uint256 riskRatio);
    event FreezeActivated(address protocol);

    function tagFreeze(address protocol, uint256 riskRatio, string memory stewardNote) public {
        freezeSignals[protocol] = FreezeSignal(protocol, riskRatio, false, stewardNote);
        emit FreezeTagged(protocol, riskRatio);
    }

    function activateFreeze(address protocol) public {
        require(freezeSignals[protocol].riskRatio >= 1, "Risk ratio not critical");
        freezeSignals[protocol].freezeActivated = true;
        emit FreezeActivated(protocol);
    }

    function getFreezeStatus(address protocol) public view returns (FreezeSignal memory) {
        return freezeSignals[protocol];
    }
}
