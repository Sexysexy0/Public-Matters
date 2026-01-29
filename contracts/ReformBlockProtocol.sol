pragma solidity ^0.8.20;

contract ReformBlockProtocol {
    address public admin;

    struct Block {
        string reform;       // e.g. Industrial policy, Land reform
        string obstacle;     // e.g. Political resistance, Weak accountability
        uint256 timestamp;
    }

    Block[] public blocks;

    event BlockLogged(string reform, string obstacle, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBlock(string calldata reform, string calldata obstacle) external onlyAdmin {
        blocks.push(Block(reform, obstacle, block.timestamp));
        emit BlockLogged(reform, obstacle, block.timestamp);
    }

    function totalBlocks() external view returns (uint256) {
        return blocks.length;
    }
}
