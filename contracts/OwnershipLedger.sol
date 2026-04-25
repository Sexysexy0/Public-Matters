// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OwnershipLedger {
    event OwnershipSeal(address player, string game);

    function grantOwnership(address _player, string memory _game) external {
        emit OwnershipSeal(_player, _game);
        // RULE: Purchased game remains playable even if servers shut down.
    }
}
