// contracts/TariffReliefProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TariffReliefProtocol
 * @notice Ensures validator-grade dignity in affordability solutions via tariff moratoriums.
 */
contract TariffReliefProtocol {
    address public admin;

    struct Relief {
        string product;     // "Bananas", "Pineapples", "Potash"
        string action;      // "ZeroTariff", "ReducedTariff"
        uint256 timestamp;
    }

    Relief[] public reliefs;

    event ReliefLogged(string product, string action, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRelief(string calldata product, string calldata action) external onlyAdmin {
        reliefs.push(Relief(product, action, block.timestamp));
        emit ReliefLogged(product, action, block.timestamp);
    }

    function totalReliefs() external view returns (uint256) { return reliefs.length; }

    function getRelief(uint256 id) external view returns (Relief memory) {
        require(id < reliefs.length, "Invalid id");
        return reliefs[id];
    }
}
