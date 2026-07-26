// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SkillBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event ScholarshipVoucher(address applicant, string program);

    function issueVoucher(address _applicant, string memory _program) external {
        emit ScholarshipVoucher(_applicant, _program);
        // BRIDGE: Graduate linked to training program.
    }
}
