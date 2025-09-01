// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SignalBypassOracle {
    struct SignalNode {
        string nodeID;
        string region;
        bool isEncrypted;
        bool isBypassed;
        uint256 timestamp;
    }

    mapping(string => SignalNode) public signalNodes;
    string[] public bypassedNodes;

    event SignalDetected(string nodeID, string region, bool isEncrypted, uint256 timestamp);
    event SignalBypassed(string nodeID, string region, uint256 timestamp);

    function detectSignal(string memory _nodeID, string memory _region, bool _isEncrypted) public {
        require(bytes(_nodeID).length > 0, "Invalid node ID");
        uint256 time = block.timestamp;

        signalNodes[_nodeID] = SignalNode(_nodeID, _region, _isEncrypted, false, time);
        emit SignalDetected(_nodeID, _region, _isEncrypted, time);
    }

    function bypassSignal(string memory _nodeID) public {
        require(signalNodes[_nodeID].isEncrypted, "Signal not encrypted");
        require(!signalNodes[_nodeID].isBypassed, "Already bypassed");

        signalNodes[_nodeID].isBypassed = true;
        bypassedNodes.push(_nodeID);

        emit SignalBypassed(_nodeID, signalNodes[_nodeID].region, block.timestamp);
    }

    function getBypassedNodes() public view returns (string[] memory) {
        return bypassedNodes;
    }
}
