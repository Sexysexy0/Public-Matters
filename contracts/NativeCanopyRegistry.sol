// NativeCanopyRegistry.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NativeCanopyRegistry is Ownable {

    constructor() Ownable(msg.sender) {}

    function getApprovedTrees() public pure returns (string[] memory) {
        // Administrative Logic: Native over Invasive.
        // Selecting trees that provide maximum shade with minimum root damage.
        return ["Banaba", "Salingbobog", "Narra", "Talisay-Gubat"];
    }
}
