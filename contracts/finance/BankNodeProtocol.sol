// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BankNodeProtocol {
    struct BankNode {
        string name;
        string jurisdiction;
        address nodeAddress;
        bool isActive;
        uint256 emotionalAPR;
    }

    mapping(address => BankNode) public bankNodes;

    event BankNodeRegistered(address indexed node, string name, string jurisdiction);
    event BankNodeStatusUpdated(address indexed node, bool isActive);

    function registerBankNode(string memory name, string memory jurisdiction, uint256 emotionalAPR) external {
        bankNodes[msg.sender] = BankNode(name, jurisdiction, msg.sender, true, emotionalAPR);
        emit BankNodeRegistered(msg.sender, name, jurisdiction);
    }

    function updateStatus(bool status) external {
        require(bankNodes[msg.sender].nodeAddress != address(0), "Bank not registered");
        bankNodes[msg.sender].isActive = status;
        emit BankNodeStatusUpdated(msg.sender, status);
    }
}
