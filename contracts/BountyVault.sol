// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BountyVault
/// @notice Simple escrow for conditional payouts (bounties, remediation)
contract BountyVault {
    address public owner;
    struct Bounty { uint amount; address payable recipient; bool paid; }
    mapping(uint => Bounty) public bounties;
    uint public nextId;

    event BountyCreated(uint indexed id, uint amount);
    event BountyPaid(uint indexed id, address recipient, uint amount);

    modifier onlyOwner() { require(msg.sender == owner, "only owner"); _; }

    constructor() { owner = msg.sender; }

    function createBounty() external payable onlyOwner returns (uint) {
        require(msg.value > 0, "no funds");
        uint id = nextId++;
        bounties[id] = Bounty(msg.value, payable(address(0)), false);
        emit BountyCreated(id, msg.value);
        return id;
    }

    function payBounty(uint id, address payable recipient) external onlyOwner {
        Bounty storage b = bounties[id];
        require(!b.paid, "already paid");
        b.paid = true;
        b.recipient = recipient;
        uint amount = b.amount;
        (bool ok, ) = recipient.call{value: amount}("");
        require(ok, "transfer failed");
        emit BountyPaid(id, recipient, amount);
    }

    receive() external payable {}
}
