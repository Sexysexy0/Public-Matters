// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KinderQueenTransitDeck {
    address public scrollsmith;
    uint256 public totalTransitFund = 50_000_000_000 * 1e18; // $50B allocation

    struct TransitNode {
        string city;
        string routeName;
        uint256 allocated;
        bool completed;
        string joyIndexTag;
        string safetyProtocol;
        uint256 timestamp;
    }

    mapping(uint256 => TransitNode) public nodes;
    uint256 public nextNodeId;

    event TransitNodeRegistered(string city, string routeName, uint256 allocated);
    event TransitNodeCompleted(string routeName);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function registerTransitNode(
        string calldata city,
        string calldata routeName,
        uint256 allocated,
        string calldata joyIndexTag,
        string calldata safetyProtocol
    ) external onlyScrollsmith {
        require(allocated <= totalTransitFund, "Insufficient fund");

        nodes[nextNodeId] = TransitNode({
            city: city,
            routeName: routeName,
            allocated: allocated,
            completed: false,
            joyIndexTag: joyIndexTag,
            safetyProtocol: safetyProtocol,
            timestamp: block.timestamp
        });

        totalTransitFund -= allocated;
        emit TransitNodeRegistered(city, routeName, allocated);
        nextNodeId++;
    }

    function markCompleted(uint256 id) external onlyScrollsmith {
        nodes[id].completed = true;
        emit TransitNodeCompleted(nodes[id].routeName);
    }
}
