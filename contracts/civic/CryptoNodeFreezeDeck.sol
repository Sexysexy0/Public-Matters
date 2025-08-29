// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract CryptoNodeFreezeDeck {
    address public steward;

    struct NodeFreeze {
        string owner;
        address wallet;
        string exchange;
        string reason;
        bool frozen;
        uint256 timestamp;
    }

    NodeFreeze[] public frozenNodes;

    event NodeFrozen(string owner, string exchange, address wallet);

    constructor() {
        steward = msg.sender;
    }

    function freezeNode(
        string memory owner,
        address wallet,
        string memory exchange,
        string memory reason
    ) public {
        frozenNodes.push(NodeFreeze(owner, wallet, exchange, reason, true, block.timestamp));
        emit NodeFrozen(owner, exchange, wallet);
    }

    function getFrozenNode(uint256 index) public view returns (NodeFreeze memory) {
        return frozenNodes[index];
    }

    function totalFrozenNodes() public view returns (uint256) {
        return frozenNodes.length;
    }
}
