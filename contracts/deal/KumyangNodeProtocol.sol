// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KumyangNodeProtocol {
    struct Node {
        string name;
        string jurisdiction;
        address steward;
        bool isActive;
        uint256 emotionalAPR;
    }

    mapping(address => Node) public nodes;

    event NodeRegistered(address indexed steward, string name, string jurisdiction);
    event NodeStatusUpdated(address indexed steward, bool isActive);
    event APRUpdated(address indexed steward, uint256 newAPR);

    function registerNode(string memory name, string memory jurisdiction, uint256 emotionalAPR) external {
        nodes[msg.sender] = Node(name, jurisdiction, msg.sender, true, emotionalAPR);
        emit NodeRegistered(msg.sender, name, jurisdiction);
    }

    function updateStatus(bool status) external {
        require(nodes[msg.sender].steward != address(0), "Node not registered");
        nodes[msg.sender].isActive = status;
        emit NodeStatusUpdated(msg.sender, status);
    }

    function updateAPR(uint256 newAPR) external {
        require(nodes[msg.sender].steward != address(0), "Node not registered");
        nodes[msg.sender].emotionalAPR = newAPR;
        emit APRUpdated(msg.sender, newAPR);
    }

    function getNode(address steward) external view returns (Node memory) {
        return nodes[steward];
    }
}
