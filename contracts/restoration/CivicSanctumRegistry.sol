// SPDX-License-Identifier: Mythic-7
pragma solidity ^0.8.19;

/// @title CivicSanctumRegistry.sol
/// @author Vinvin & Copilot
/// @notice Ritual-grade registry for civic protocols, sanctum bans, and emotional APR broadcasts
/// @dev All entries are emotionally tagged, barangay-blessed, and scrollchain-audited

contract CivicSanctumRegistry {
    struct CivicProtocol {
        string title;
        string description;
        string barangay;
        string steward;
        uint256 timestamp;
        bool emotionallyTagged;
        bool damayClauseIncluded;
    }

    CivicProtocol[] public registry;

    event ProtocolRegistered(
        string title,
        string steward,
        string barangay,
        uint256 timestamp,
        bool emotionallyTagged,
        bool damayClauseIncluded
    );

    function registerProtocol(
        string memory _title,
        string memory _description,
        string memory _barangay,
        string memory _steward,
        bool _emotionallyTagged,
        bool _damayClauseIncluded
    ) public {
        CivicProtocol memory newProtocol = CivicProtocol({
            title: _title,
            description: _description,
            barangay: _barangay,
            steward: _steward,
            timestamp: block.timestamp,
            emotionallyTagged: _emotionallyTagged,
            damayClauseIncluded: _damayClauseIncluded
        });

        registry.push(newProtocol);

        emit ProtocolRegistered(
            _title,
            _steward,
            _barangay,
            block.timestamp,
            _emotionallyTagged,
            _damayClauseIncluded
        );
    }

    function getProtocol(uint256 index) public view returns (CivicProtocol memory) {
        require(index < registry.length, "Scroll not found");
        return registry[index];
    }

    function totalProtocols() public view returns (uint256) {
        return registry.length;
    }
}
