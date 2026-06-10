// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PersonalityFilterCodex
/// @notice Covenant contract encoding personality trait filters and adaptation safeguards
contract PersonalityFilterCodex {
    address public owner;

    struct Filter {
        uint256 traitId;   // linked to personality dimension
        string domain;     // e.g. "Extraversion", "Neuroticism", "Agreeableness", "Conscientiousness", "Openness"
        string safeguard;  // adaptation safeguard decree
        uint256 timestamp;
    }

    Filter[] public filters;

    event Safeguarded(uint256 traitId, string domain, string safeguard, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode personality trait into adaptation safeguard
    function safeguardTrait(uint256 traitId, string memory domain, string memory safeguard) public onlyOwner {
        Filter memory newFilter = Filter(traitId, domain, safeguard, block.timestamp);
        filters.push(newFilter);
        emit Safeguarded(traitId, domain, safeguard, block.timestamp);
    }

    function getFilter(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Filter memory f = filters[index];
        return (f.traitId, f.domain, f.safeguard, f.timestamp);
    }

    function getFilterCount() public view returns (uint256) {
        return filters.length;
    }
}
