pragma solidity ^0.8.0;

contract FarmSurplusAidProtocol {
    event AidActivation(string recipient, string item, uint256 quantity);

    function distributeSurplus(string memory recipient, string memory item, uint256 quantity) public {
        emit AidActivation(recipient, item, quantity);
    }
}
