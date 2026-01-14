pragma solidity ^0.8.20;

contract CensorshipProtocol {
    address public admin;

    struct Block {
        string command;      // e.g. unsafe request
        string reason;       // e.g. policy violation, explicit content
        uint256 timestamp;
    }

    Block[] public blocks;

    event BlockLogged(string command, string reason, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBlock(string calldata command, string calldata reason) external onlyAdmin {
        blocks.push(Block(command, reason, block.timestamp));
        emit BlockLogged(command, reason, block.timestamp);
    }

    function totalBlocks() external view returns (uint256) {
        return blocks.length;
    }
}
