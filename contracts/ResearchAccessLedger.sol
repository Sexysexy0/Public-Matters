// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResearchAccessLedger {
    event ResearchSeal(address researcher, string project);

    function grantAccess(address _researcher, string memory _project) external {
        emit ResearchSeal(_researcher, _project);
        // RULE: Easier access for medical marijuana research.
    }
}
