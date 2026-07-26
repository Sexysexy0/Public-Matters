// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract HarvestNowOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    event HarvestRecord(string actor, string status);

    function logHarvest(string memory _actor, string memory _status) external {
        emit HarvestRecord(_actor, _status);
        // ORACLE: Harvest-now-decrypt-later risk monitored.
    }
}
