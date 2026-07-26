// DataSovereigntyVault.sol
pragma solidity ^0.8.0;

contract DataSovereigntyVault {
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
        payable(msg.sender).transfer(msg.value);
    }
}
