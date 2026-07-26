// LockedFurnaceAccess.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LockedFurnaceAccess is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => bool) public isTrusted;

    function requestWarmth(address _user) public view {
        require(isTrusted[_user], "ACCESS DENIED: THE DOOR IS LOCKED");
        // Administrative Logic: Protection from emotional/resource vampires.
    }
}
