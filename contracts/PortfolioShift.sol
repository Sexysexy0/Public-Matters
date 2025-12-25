// contracts/PortfolioShift.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PortfolioShift
 * @notice Logs equity/bond ratio changes and communal diversification arcs.
 */
contract PortfolioShift {
    address public admin;

    struct Mix {
        uint256 equityShare;   // percentage
        uint256 bondShare;     // percentage
        string outlook;        // "MediumTerm", "LongTerm"
        uint256 timestamp;
    }

    Mix[] public mixes;

    event MixLogged(uint256 equityShare, uint256 bondShare, string outlook, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMix(uint256 equityShare, uint256 bondShare, string calldata outlook) external onlyAdmin {
        mixes.push(Mix(equityShare, bondShare, outlook, block.timestamp));
        emit MixLogged(equityShare, bondShare, outlook, block.timestamp);
    }

    function totalMixes() external view returns (uint256) { return mixes.length; }

    function getMix(uint256 id) external view returns (Mix memory) {
        require(id < mixes.length, "Invalid id");
        return mixes[id];
    }
}
