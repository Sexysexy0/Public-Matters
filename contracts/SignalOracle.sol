// contracts/SignalOracle.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SignalOracle
 * @notice On-chain ingress for adaptive traffic timing data.
 */
contract SignalOracle {
    address public owner;
    mapping(string => uint256) public intersectionFlow; // intersection → vehicles per minute

    event FlowUpdated(string indexed intersection, uint256 flow);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function updateFlow(string calldata intersection, uint256 flow) external onlyOwner {
        intersectionFlow[intersection] = flow;
        emit FlowUpdated(intersection, flow);
    }

    function getFlow(string calldata intersection) external view returns (uint256) {
        return intersectionFlow[intersection];
    }
}
