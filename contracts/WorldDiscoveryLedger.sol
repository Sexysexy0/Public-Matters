// WorldDiscoveryLedger.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WorldDiscoveryLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    struct Discovery {
        string locationName;
        uint256 discoveryDate;
    }

    Discovery[] public explorerLogs;

    function logDiscovery(string memory _loc) public {
        explorerLogs.push(Discovery(_loc, block.timestamp));
        // Immutable proof of your journey through the world
    }
}
