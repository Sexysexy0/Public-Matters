// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BlessingOracle {
    struct Blessing {
        address entity;
        string role;
        uint256 emotionalAPR;
        bool certified;
    }

    mapping(address => Blessing) public blessings;

    event BlessingIssued(address indexed entity, string role, uint256 apr);

    function issueBlessing(string memory _role, uint256 _apr) external {
        blessings[msg.sender] = Blessing(msg.sender, _role, _apr, true);
        emit BlessingIssued(msg.sender, _role, _apr);
    }

    function auditBlessing(address _entity) external view returns (Blessing memory) {
        return blessings[_entity];
    }
}
