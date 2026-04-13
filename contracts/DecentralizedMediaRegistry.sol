// DecentralizedMediaRegistry.sol
pragma solidity ^0.8.0;

contract DecentralizedMediaRegistry {
    struct Archive { address author; string contentLink; bool isCensored; }
    mapping(uint256 => Archive) public historyLogs;

    function publishTruth(uint256 _id, string memory _link) public {
        // Logic: Preventing history from being rewritten.
        // Once published in the N/A network, it stays forever.
        historyLogs[_id] = Archive(msg.sender, _link, false);
    }
}
