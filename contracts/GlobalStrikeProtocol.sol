pragma solidity ^0.8.0;

contract GlobalStrikeProtocol {
    event StrikeSignal(string port, string action);

    function triggerStrike(string memory port) public {
        emit StrikeSignal(port, "Suspend operations until fair treatment achieved");
    }
}
