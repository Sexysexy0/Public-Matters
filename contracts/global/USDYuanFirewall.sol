// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.9.27;

contract USDYuanFirewall {
    address public steward;
    bool public pairingEnabled = true;

    event PairingDisabled(string reason, uint256 timestamp);
    event PairingRestored(string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function disablePairing(string memory reason) public onlySteward {
        pairingEnabled = false;
        emit PairingDisabled(reason, block.timestamp);
    }

    function restorePairing(string memory reason) public onlySteward {
        pairingEnabled = true;
        emit PairingRestored(reason, block.timestamp);
    }

    function isPairingActive() public view returns (bool) {
        return pairingEnabled;
    }
}
