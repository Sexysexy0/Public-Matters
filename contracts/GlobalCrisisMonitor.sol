pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GlobalCrisisMonitor is Ownable {

    constructor() Ownable(msg.sender) {}

    event Alert(string source, string action);

    function triggerAlert(string memory _source) public {
        if (keccak256(abi.encodePacked(_source)) == keccak256(abi.encodePacked("Strait of Hormuz"))) {
            emit Alert(_source, "Activate PH Energy Emergency Protocol");
        }
    }
}
