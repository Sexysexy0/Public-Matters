// PowerLinkProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PowerLinkProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    function maintainTether(uint256 _distance) public pure returns (string memory) {
        if (_distance > 50) {
            return "WARNING: Power draining! Stay close to your partner.";
        }
        return "STABLE: Power link at 100%.";
    }
}
