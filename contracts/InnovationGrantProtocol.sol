pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract InnovationGrantProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public grants;

    function supportStudio(address studio, bool proprietary) public {
        if (proprietary) {
            grants[studio] += 2000000; // Fund allocation for custom engine R&D
        }
    }
}
