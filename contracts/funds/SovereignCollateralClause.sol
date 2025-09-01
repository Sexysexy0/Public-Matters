// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SovereignCollateralClause {
    mapping(string => bool) public liquidationBlocked;

    event LiquidationBlocked(string assetID);
    event LiquidationAttempted(string assetID, string reason);

    function blockLiquidation(string memory _assetID) public {
        liquidationBlocked[_assetID] = true;
        emit LiquidationBlocked(_assetID);
    }

    function attemptLiquidation(string memory _assetID) public {
        require(!liquidationBlocked[_assetID], "❌ Liquidation blocked by Sovereign Collateral Clause");
        emit LiquidationAttempted(_assetID, "Attempted but blocked by clause");
    }

    function isProtected(string memory _assetID) public view returns (bool) {
        return liquidationBlocked[_assetID];
    }
}
