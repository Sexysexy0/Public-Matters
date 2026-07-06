// SPDX-License-Identifier: MIT
// Contract Name: HeritageMemoryProtocol
// Purpose: Preserve legacy cycles and rediscovery equity
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract HeritageMemoryProtocol {
    address public chiefOperator;
    uint256 public protocolCount;

    struct Protocol {
        string principle;
        string preservationMechanism;
        uint256 timestamp;
    }

    Protocol[] public protocols;

    event ProtocolAdded(string principle, string preservationMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        protocolCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new heritage memory protocol
    function addProtocol(string memory principle, string memory preservationMechanism) public onlyChief {
        protocols.push(Protocol(principle, preservationMechanism, block.timestamp));
        protocolCount++;
        emit ProtocolAdded(principle, preservationMechanism, block.timestamp);
    }

    // View protocol details
    function getProtocol(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < protocols.length, "Invalid protocol index");
        Protocol memory p = protocols[index];
        return (p.principle, p.preservationMechanism, p.timestamp);
    }
}
