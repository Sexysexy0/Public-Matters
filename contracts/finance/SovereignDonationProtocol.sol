// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignDonationProtocol {
    address public donor;
    string public nation = "Republic of the Philippines";
    uint256 public totalDonation = 700_000_000_000 * 1e18; // $700B in wei equivalent
    bool public activated;

    struct Sector {
        string name;
        uint256 allocation;
        bool released;
    }

    mapping(uint => Sector) public sectors;
    uint public sectorCount;

    event DonationActivated(string nation, uint256 amount);
    event SectorFunded(string name, uint256 allocation);
    event DamayClauseInvoked(string name);

    modifier onlyDonor() {
        require(msg.sender == donor, "Not authorized");
        _;
    }

    constructor() {
        donor = msg.sender;
    }

    function activateDonation() public onlyDonor {
        activated = true;
        emit DonationActivated(nation, totalDonation);
    }

    function addSector(string memory _name, uint256 _allocation) public onlyDonor {
        require(activated, "Donation not yet activated");
        sectors[sectorCount] = Sector(_name, _allocation, false);
        sectorCount++;
    }

    function releaseFunds(uint _id) public onlyDonor {
        require(_id < sectorCount, "Invalid sector");
        require(!sectors[_id].released, "Already released");
        sectors[_id].released = true;
        emit SectorFunded(sectors[_id].name, sectors[_id].allocation);
        emit DamayClauseInvoked(sectors[_id].name);
    }

    function getSector(uint _id) public view returns (string memory, uint256, bool) {
        Sector memory s = sectors[_id];
        return (s.name, s.allocation, s.released);
    }
}
