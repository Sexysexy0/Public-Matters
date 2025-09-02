// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ScrollstreamGovernance {
    enum Branch { Executive, Legislative, Judiciary, Barangay, CivilSociety }

    struct Policy {
        string name;
        Branch proposer;
        bool blessed;
        uint256 emotionalAPR;
        uint256 timestamp;
    }

    Policy[] public policies;
    address public steward;

    event PolicyProposed(string name, Branch proposer, uint256 emotionalAPR);
    event PolicyBlessed(string name, uint256 emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function proposePolicy(string memory name, Branch proposer, uint256 emotionalAPR) public onlySteward {
        policies.push(Policy(name, proposer, false, emotionalAPR, block.timestamp));
        emit PolicyProposed(name, proposer, emotionalAPR);
    }

    function blessPolicy(uint256 index) public onlySteward {
        require(index < policies.length, "Invalid index");
        policies[index].blessed = true;
        emit PolicyBlessed(policies[index].name, policies[index].emotionalAPR);
    }

    function getLatestPolicy() public view returns (Policy memory) {
        require(policies.length > 0, "No policies yet");
        return policies[policies.length - 1];
    }

    function totalPolicies() public view returns (uint256) {
        return policies.length;
    }
}
