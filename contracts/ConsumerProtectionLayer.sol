pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ConsumerProtectionLayer is Ownable {

    constructor() Ownable(msg.sender) {}

    event RefundTriggered(string game, address player);

    function requestRefund(string memory game, address player, uint256 fps) public {
        if (fps < 30) {
            emit RefundTriggered(game, player);
        }
    }
}
