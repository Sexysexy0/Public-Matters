// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WorkModelLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event WorkSeal(string company, string model);

    function logModel(string memory _company, string memory _model) external {
        emit WorkSeal(_company, _model);
        // LEDGER: Work model preference logged (remote, hybrid, RTO).
    }
}
