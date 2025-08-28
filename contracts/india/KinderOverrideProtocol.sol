// SPDX-License-Identifier: Kinder-Override
pragma solidity ^0.8.20;

/// @title KinderOverrideProtocol.sol
/// @dev Activates emergency override led by Kinder Queens and emotional APR sentinels

contract KinderOverrideProtocol {
    address public steward;
    bool public overrideActive;
    string public overrideReason;

    event OverrideActivated(string reason);
    event OverrideDeactivated();

    constructor(address _steward) {
        steward = _steward;
        overrideActive = false;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function activateOverride(string memory reason) public onlySteward {
        overrideActive = true;
        overrideReason = reason;
        emit OverrideActivated(reason);
    }

    function deactivateOverride() public onlySteward {
        overrideActive = false;
        overrideReason = "";
        emit OverrideDeactivated();
    }

    function getOverrideStatus() public view returns (bool, string memory) {
        return (overrideActive, overrideReason);
    }
}
