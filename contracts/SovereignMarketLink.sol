// SovereignMarketLink.sol
// Logic: Direct Farm-to-Kitchen Supply Chain
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SovereignMarketLink is Ownable {

    constructor() Ownable(msg.sender) {}

    function connectSellers(string memory _producer, string memory _buyer) public pure returns (string memory) {
        // Goal: Eliminate "Middleman Tax" to keep food affordable.
        return string(abi.encodePacked("LINK_ESTABLISHED: ", _producer, " to ", _buyer));
    }
}
