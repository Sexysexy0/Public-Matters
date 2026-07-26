// RegulatorySafeHarbor.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RegulatorySafeHarbor is Ownable {

    constructor() Ownable(msg.sender) {}

    function isNonCustodial() public pure returns (bool) {
        // Goal: Compliance by Architecture.
        // Connecting users to markets without handling their private keys.
        return true;
    }
}
