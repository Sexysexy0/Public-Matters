// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoSanctumDAO {
    struct Proposal {
        string title;
        string description;
        bool isApproved;
    }

    Proposal[] public proposals;
    mapping(address => bool) public blessedVoters;

    modifier onlyBlessed() {
        require(blessedVoters[msg.sender], "Not a blessed steward");
        _;
    }

    function blessSteward(address _steward) public {
        blessedVoters[_steward] = true;
    }

    function submitProposal(string memory _title, string memory _description) public onlyBlessed {
        proposals.push(Proposal(_title, _description, false));
    }

    function approveProposal(uint _index) public onlyBlessed {
        proposals[_index].isApproved = true;
    }

    function getProposal(uint _index) public view returns (Proposal memory) {
        return proposals[_index];
    }
}
