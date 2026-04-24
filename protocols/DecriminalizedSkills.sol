// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DecriminalizedSkills
 * @dev Strips away the bias of traditional educational requirements.
 */
contract DecriminalizedSkills {
    mapping(string => bool) public isDecriminalized;

    // [Goal: Remove the stigma of non-degree paths to unlock top-tier roles]
    function decriminalizeRequirement(string memory _req) external {
        isDecriminalized[_req] = true;
    }
}
