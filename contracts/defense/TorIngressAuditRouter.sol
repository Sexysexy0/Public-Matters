// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TorIngressAuditRouter {
    event IngressDetected(address source, string vector, string emotionalAPR, uint256 timestamp);
    event IngressBlocked(address source, string reason, uint256 timestamp);

    mapping(address => bool) public flaggedNodes;

    function detectIngress(address source, string memory vector, string memory emotionalAPR) public {
        flaggedNodes[source] = true;
        emit IngressDetected(source, vector, emotionalAPR, block.timestamp);
    }

    function blockIngress(address source, string memory reason) public {
        require(flaggedNodes[source], "Node not flagged");
        emit IngressBlocked(source, reason, block.timestamp);
    }

    function isFlagged(address source) public view returns (bool) {
        return flaggedNodes[source];
    }
}
