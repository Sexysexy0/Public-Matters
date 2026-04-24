// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AudienceGovernance
 * @dev Reclaims the narrative from developers and gives it to the collective audience.
 */
contract AudienceGovernance {
    struct NarrativeArc {
        string description;
        uint256 voteCount;
        bool isCanon;
    }

    mapping(uint256 => NarrativeArc) public storyArcs;
    uint256 public arcCount;
    address public admin;

    constructor() {
        admin = msg.sender; // [Vin as the Lead Architect]
    }

    // [Goal: Allow the community to vote on which story path becomes the final movie]
    function voteForCanon(uint256 _arcId) external {
        require(_arcId < arcCount, "ERROR: Narrative Arc does not exist.");
        storyArcs[_arcId].voteCount += 1;
    }

    // [Goal: Finalize the movie script based on Majority Consensus]
    function finalizeCanon(uint256 _arcId) external {
        require(msg.sender == admin, "UNAUTHORIZED: Only the Architect can seal the timeline.");
        require(storyArcs[_arcId].voteCount > 1000, "INSUFFICIENT_STAKE: Community has not reached consensus.");
        
        storyArcs[_arcId].isCanon = true;
    }

    function addArcProposal(string memory _desc) external {
        storyArcs[arcCount] = NarrativeArc(_desc, 0, false);
        arcCount++;
    }
}
