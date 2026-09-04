// SPDX-License-Identifier: WIZARD-GENESIS-V1
pragma solidity ^0.8.24;

contract PresidentialPolicyDAO {
    address public admin;
    struct Policy {
        string content;
        uint256 timestamp;
        bool active;
    }
    Policy[] public policies;
    event PolicyIssued(uint256 indexed id, string content);

    constructor() {
        admin = msg.sender;
    }

    function issuePolicy(string memory _content) public onlyAdmin {
        policies.push(Policy({
            content: _content,
            timestamp: block.timestamp,
            active: true
        }));
        emit PolicyIssued(policies.length - 1, _content);
    }

    function getPolicy(uint256 _id) public view returns (string memory, uint256, bool) {
        require(_id < policies.length, "Invalid ID");
        Policy memory p = policies[_id];
        return (p.content, p.timestamp, p.active);
    }

    function revokePolicy(uint256 _id) public onlyAdmin {
        require(_id < policies.length, "Invalid ID");
        policies[_id].active = false;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }
}
