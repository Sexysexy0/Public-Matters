// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CombatSandbox {
    event AbilityChain(address player, string combo);

    function logCombo(address _player, string memory _combo) external {
        emit AbilityChain(_player, _combo);
        // SANDBOX: Reward chaining abilities, not rigid Soulslike.
    }
}
