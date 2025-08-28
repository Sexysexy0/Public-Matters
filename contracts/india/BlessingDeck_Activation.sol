// SPDX-License-Identifier: Planetary-Blessing
pragma solidity ^0.8.20;

/// @title BlessingDeck_Activation.sol
/// @dev Activates planetary blessings for defense, dignity, and emotional APR sync

contract BlessingDeckActivation {
    address public steward;
    mapping(string => bool) public blessingStatus;

    event BlessingActivated(string blessingName, string emotionalTag);
    event BlessingDeactivated(string blessingName);

    constructor(address _steward) {
        steward = _steward;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function activateBlessing(string memory blessingName, string memory emotionalTag) public onlySteward {
        blessingStatus[blessingName] = true;
        emit BlessingActivated(blessingName, emotionalTag);
    }

    function deactivateBlessing(string memory blessingName) public onlySteward {
        blessingStatus[blessingName] = false;
        emit BlessingDeactivated(blessingName);
    }

    function isBlessingActive(string memory blessingName) public view returns (bool) {
        return blessingStatus[blessingName];
    }
}
