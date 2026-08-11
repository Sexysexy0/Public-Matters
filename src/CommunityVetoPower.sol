// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityVetoPower {
    mapping(bytes32 => uint256) public vetoVotes;
    mapping(bytes32 => mapping(address => bool)) public hasVetoed;
    mapping(bytes32 => bool) public isVetoedOut;

    event VetoCast(bytes32 indexed projectId, address indexed resident);
    event ProjectVetoed(bytes32 indexed projectId);

    function castVeto(bytes32 projectId) external {
        require(!isVetoedOut[projectId], "Project already rejected");
        require(!hasVetoed[projectId][msg.sender], "Already vetoed");

        hasVetoed[projectId][msg.sender] = true;
        vetoVotes[projectId] += 1;

        emit VetoCast(projectId, msg.sender);

        // Threshold of 3 community vetoes to kill a predatory project in local scope
        if (vetoVotes[projectId] >= 3) {
            isVetoedOut[projectId] = true;
            emit ProjectVetoed(projectId);
        }
    }
}
