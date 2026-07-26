// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SurvivalLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event SurvivalTokenIssued(address player);

    function issueToken(address _player) external {
        emit SurvivalTokenIssued(_player);
        // TOKEN: Equal access to Haga Basin survival resources.
    }
}
