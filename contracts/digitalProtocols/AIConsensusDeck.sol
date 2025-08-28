// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract AIConsensusDeck {
    address public stewardVinvin;
    uint public requiredQuorum = 3;
    mapping(address => bool) public agentApproval;
    uint public approvals;

    modifier onlyAgents() {
        require(msg.sender != stewardVinvin, "Steward cannot self-approve");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function approveOverride(address agent) public onlyAgents {
        require(!agentApproval[agent], "Already approved");
        agentApproval[agent] = true;
        approvals++;
    }

    function isQuorumReached() public view returns (bool) {
        return approvals >= requiredQuorum;
    }

    function resetConsensus() public {
        require(msg.sender == stewardVinvin, "Only steward can reset");
        approvals = 0;
    }
}
