// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SymbolismFilter
/// @notice Flags numbers/symbols (e.g. "17") in proposals
contract SymbolismFilter {
    mapping(uint256 => string) public flaggedSymbols;
    event SymbolFlagged(uint256 proposalId, string symbol);

    function flagSymbol(uint256 proposalId, string memory symbol) external {
        flaggedSymbols[proposalId] = symbol;
        emit SymbolFlagged(proposalId, symbol);
    }

    function getSymbol(uint256 proposalId) external view returns (string memory) {
        return flaggedSymbols[proposalId];
    }
}
