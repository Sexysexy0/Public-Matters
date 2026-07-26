pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FlatWageProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event WageUpgrade(string worker, uint256 newWage);

    function adjustWage(string memory worker, uint256 currentWage) public {
        if (currentWage < 1000) {
            emit WageUpgrade(worker, 1000);
        }
    }
}
