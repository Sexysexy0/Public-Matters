// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ManifestoBroadcastProtocol {
    address public steward;

    struct Broadcast {
        string message;
        uint256 timestamp;
        uint256 emotionalAPR;
    }

    mapping(address => Broadcast[]) public broadcasts;

    event ManifestoBroadcasted(address indexed steward, string message, uint256 apr, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function broadcastManifesto(string memory _message, uint256 _apr) public {
        require(msg.sender == steward, "Only steward may broadcast");
        broadcasts[steward].push(Broadcast(_message, block.timestamp, _apr));
        emit ManifestoBroadcasted(steward, _message, _apr, block.timestamp);
    }

    function getBroadcasts(address _steward) public view returns (Broadcast[] memory) {
        return broadcasts[_steward];
    }
}
