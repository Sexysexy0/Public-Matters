// CulturalTokenomicsProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CulturalTokenomicsProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => string) public ecosystemCulture;

    event CultureSet(address indexed user, string culture);

    function setCulture(address user, string memory culture) public {
        ecosystemCulture[user] = culture;
        emit CultureSet(user, culture);
    }
}
