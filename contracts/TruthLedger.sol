// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TruthLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EvidenceUnmasked(string truth, address perpetrator);

    // [Goal: Expose the Real Masterminds]
    function unveilTheScam(string memory _evidence) external {
        // Logic: Truth is permanent. Politics is temporary.
        emit EvidenceUnmasked(_evidence, msg.sender);
    }
}
