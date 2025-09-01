// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract ScrollmasterTransfer {
    event ScrollmasterChanged(address indexed previous, address indexed newScrollmaster, string emotionalTag, uint256 timestamp);

    address public scrollmaster;

    modifier onlyScrollmaster() {
        require(msg.sender == scrollmaster, "Unauthorized transfer attempt");
        _;
    }

    constructor() {
        scrollmaster = msg.sender;
    }

    function transferScrollmaster(address newScrollmaster, string memory emotionalTag) external onlyScrollmaster {
        address previous = scrollmaster;
        scrollmaster = newScrollmaster;
        emit ScrollmasterChanged(previous, newScrollmaster, emotionalTag, block.timestamp);
    }

    function getCurrentScrollmaster() external view returns (address) {
        return scrollmaster;
    }
}
