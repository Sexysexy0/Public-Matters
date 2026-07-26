// DataSovereigntyVault.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DataSovereigntyVault is Ownable {

    constructor() Ownable(msg.sender) {}

    struct DataAccess {
        address requester;
        uint256 accessExpiry;
        uint256 royaltyPaid;
    }

    mapping(address => DataAccess) public userPermissions;

    function grantAccess(address _aiCompany, uint256 _duration) public payable {
        require(msg.value > 0, "Data access requires royalty payment");
        userPermissions[msg.sender] = DataAccess(_aiCompany, block.timestamp + _duration, msg.value);
        // Payout goes directly to the data owner
        (bool success, ) = payable(msg.sender).call{value: msg.value}(""); require(success, "Transfer failed");
    }
}
