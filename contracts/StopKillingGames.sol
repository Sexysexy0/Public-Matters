// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract StopKillingGames is Ownable {

    constructor() Ownable(msg.sender) {}

    event SurvivabilityMode(string game, string method);

    function activateSurvivability(string memory _game, string memory _method) external {
        emit SurvivabilityMode(_game, _method);
        // RULE: Game remains playable after shutdown.
    }
}
