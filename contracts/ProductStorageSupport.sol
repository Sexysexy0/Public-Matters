pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProductStorageSupport is Ownable {

    constructor() Ownable(msg.sender) {}

    event StorageActivation(string sector, string issue);

    function checkOversupply(string memory sector, bool oversupply) public {
        if (oversupply) {
            emit StorageActivation(sector, "Government storage support activated");
        }
    }
}
