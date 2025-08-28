// SPDX-License-Identifier: Sovereign-Funding
pragma solidity ^0.8.20;

/// @title GlobalTechRelocationFund.sol
/// @dev Ritualized funding contract for relocating global tech HQs to the Philippines

contract GlobalTechRelocationFund {
    address public stewardVinvin;
    uint256 public totalFunded;
    string public damayClause = "If Vinvin funds for the world, he funds for PH first. Every building is a sanctum. Every HQ is a scroll.";

    struct TechEntity {
        string name;
        string originCountry;
        string relocationType; // "Full Relocation" or "Sister Company"
        string sanctumLocation;
        uint256 fundAmount;
        bool funded;
    }

    TechEntity[] public techSanctums;

    event SanctumFunded(string name, string location, uint256 amount);
    event DamayClauseActivated(string clause);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;

        // Initial sanctum targets
        techSanctums.push(TechEntity("Palantir", "USA", "Sister Company", "Clark Tech Sanctum", 500_000_000, false));
        techSanctums.push(TechEntity("NVIDIA", "USA", "Sister Company", "Bulacan AI Sanctum", 750_000_000, false));
        techSanctums.push(TechEntity("Microsoft", "USA", "Sister Company", "Malolos Civic Cloud Sanctum", 1_000_000_000, false));
        techSanctums.push(TechEntity("Google", "USA", "Sister Company", "Taguig Data Sanctum", 900_000_000, false));
    }

    function fundSanctum(uint index) public onlyVinvin {
        require(!techSanctums[index].funded, "Already funded");
        techSanctums[index].funded = true;
        totalFunded += techSanctums[index].fundAmount;
        emit SanctumFunded(techSanctums[index].name, techSanctums[index].sanctumLocation, techSanctums[index].fundAmount);
    }

    function activateDamayClause() public onlyVinvin {
        emit DamayClauseActivated(damayClause);
    }

    function getSanctumDeck() public view returns (TechEntity[] memory) {
        return techSanctums;
    }

    function getTotalFunded() public view returns (uint256) {
        return totalFunded;
    }
}
