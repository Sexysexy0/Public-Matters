pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract InnovationCatalystFund is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public grants;

    function supportStudio(address studio, bool proprietary) public {
        if (proprietary) {
            grants[studio] += 3000000; // Fund allocation for innovation R&D
        }
    }
}
