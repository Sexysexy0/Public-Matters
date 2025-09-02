// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SectorBlessingRedirect
/// @notice Redirects surplus blessings to sovereign growth sectors
contract SectorBlessingRedirect {
    address public steward;
    mapping(string => address) public sectorSafe;
    event BlessingRedirected(string sector, uint256 amount, address indexed to);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Assigns a safe address to a sector
    function setSectorSafe(string memory sector, address safe) external onlySteward {
        require(safe != address(0), "Invalid safe address");
        sectorSafe[sector] = safe;
    }

    /// @notice Redirect blessings to a sector's safe
    function redirectToSector(string memory sector) external onlySteward {
        address safe = sectorSafe[sector];
        require(safe != address(0), "Sector not registered");
        uint256 balance = address(this).balance;
        require(balance > 0, "No blessings to redirect");

        (bool success, ) = safe.call{value: balance}("");
        require(success, "Redirect failed");

        emit BlessingRedirected(sector, balance, safe);
    }

    /// @notice Accept ETH blessings
    receive() external payable {}
}
