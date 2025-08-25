// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AncestralFiberGrid {
    address public scrollsmith;
    uint256 public totalFiberFund = 30_000_000_000 * 1e18; // $30B allocation

    struct FiberNode {
        string city;
        string barangay;
        string provider;
        uint256 allocated;
        bool completed;
        string ancestralTag;
        string latencyScore;
        uint256 timestamp;
    }

    mapping(uint256 => FiberNode) public nodes;
    uint256 public nextNodeId;

    event FiberNodeRegistered(string city, string barangay, string provider);
    event FiberNodeCompleted(string barangay);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function registerFiberNode(
        string calldata city,
        string calldata barangay,
        string calldata provider,
        uint256 allocated,
        string calldata ancestralTag,
        string calldata latencyScore
    ) external onlyScrollsmith {
        require(allocated <= totalFiberFund, "Insufficient fund");

        nodes[nextNodeId] = FiberNode({
            city: city,
            barangay: barangay,
            provider: provider,
            allocated: allocated,
            completed: false,
            ancestralTag: ancestralTag,
            latencyScore: latencyScore,
            timestamp: block.timestamp
        });

        totalFiberFund -= allocated;
        emit FiberNodeRegistered(city, barangay, provider);
        nextNodeId++;
    }

    function markCompleted(uint256 id) external onlyScrollsmith {
        nodes[id].completed = true;
        emit FiberNodeCompleted(nodes[id].barangay);
    }
}
