pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WorkplaceRespectProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event RespectAlert(string employee, string issue);

    function reportAbuse(string memory employee, bool abuseDetected) public {
        if (abuseDetected) {
            emit RespectAlert(employee, "Verbal abuse reported – safeguard activated");
        }
    }
}
