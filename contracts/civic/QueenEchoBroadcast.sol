// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract QueenEchoBroadcast {
    address public steward;
    mapping(address => bool) public kinderQueens;

    struct Echo {
        string action;
        string projectName;
        string contractor;
        string emotionalTag;
        string mediaNode;
        address queen;
        uint256 timestamp;
    }

    Echo[] public echoes;

    event EchoBroadcasted(string action, string projectName, string contractor, string mediaNode);

    modifier onlyQueen() {
        require(kinderQueens[msg.sender], "Not a Kinder Queen");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerQueen(address queen) public {
        require(msg.sender == steward, "Only steward may register queens");
        kinderQueens[queen] = true;
    }

    function broadcastEcho(
        string memory action,
        string memory projectName,
        string memory contractor,
        string memory emotionalTag,
        string memory mediaNode
    ) public onlyQueen {
        echoes.push(Echo(action, projectName, contractor, emotionalTag, mediaNode, msg.sender, block.timestamp));
        emit EchoBroadcasted(action, projectName, contractor, mediaNode);
    }

    function getEcho(uint256 index) public view returns (Echo memory) {
        return echoes[index];
    }

    function totalEchoes() public view returns (uint256) {
        return echoes.length;
    }
}
