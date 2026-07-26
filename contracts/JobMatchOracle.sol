// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract JobMatchOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    event JobMatched(address applicant, string company);

    function matchGraduate(address _applicant, string memory _company) external {
        emit JobMatched(_applicant, _company);
        // ORACLE: Graduate matched to company vacancy.
    }
}
