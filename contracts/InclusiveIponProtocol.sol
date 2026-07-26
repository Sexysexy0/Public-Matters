// InclusiveIponProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract InclusiveIponProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public iponBalance;

    event IponAdded(address indexed worker, uint256 amount);

    function addIpon(address worker, uint256 amount) public {
        iponBalance[worker] += amount;
        emit IponAdded(worker, amount);
    }
}
