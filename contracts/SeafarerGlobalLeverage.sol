pragma solidity ^0.8.0;

contract SeafarerGlobalLeverage {
    event GlobalAlert(string port, string action);

    function triggerStrike(string memory port) public {
        emit GlobalAlert(port, "Suspend operations until fair treatment achieved");
    }
}
