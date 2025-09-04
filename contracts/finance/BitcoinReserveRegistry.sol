// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BitcoinReserveRegistry {
    struct Reserve {
        string institution;
        uint256 btcAmount;
        string purpose;
        uint256 timestamp;
    }

    Reserve[] public reserves;

    event ReserveLogged(string institution, uint256 btcAmount, string purpose);

    function logReserve(string memory institution, uint256 btcAmount, string memory purpose) external {
        reserves.push(Reserve(institution, btcAmount, purpose, block.timestamp));
        emit ReserveLogged(institution, btcAmount, purpose);
    }

    function getReserves() external view returns (Reserve[] memory) {
        return reserves;
    }
}
