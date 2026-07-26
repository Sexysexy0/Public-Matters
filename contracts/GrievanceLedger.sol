// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GrievanceLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event GrievanceSeal(string barangay, string complaint);

    function logGrievance(string memory _barangay, string memory _complaint) external {
        emit GrievanceSeal(_barangay, _complaint);
        // RULE: Barangay grievances logged for dignified resolution.
    }
}
