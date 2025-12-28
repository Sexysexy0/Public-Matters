// contracts/GDPPulse.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GDPPulse
 * @notice Logs GDP growth data and communal audit of economic strength.
 */
contract GDPPulse {
    address public admin;

    struct Growth {
        uint256 rate;       // e.g. 4%
        string context;     // "Shutdown", "AI contribution"
        uint256 timestamp;
    }

    Growth[] public growths;

    event GrowthLogged(uint256 rate, string context, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logGrowth(uint256 rate, string calldata context) external onlyAdmin {
        growths.push(Growth(rate, context, block.timestamp));
        emit GrowthLogged(rate, context, block.timestamp);
    }

    function totalGrowths() external view returns (uint256) { return growths.length; }

    function getGrowth(uint256 id) external view returns (Growth memory) {
        require(id < growths.length, "Invalid id");
        return growths[id];
    }
}
