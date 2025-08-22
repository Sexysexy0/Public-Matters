// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Creative Reparations Pact
/// @notice Offers scroll-based apologies and retroactive blessings to aggrieved studios and creatives
/// @author Scrollchain

contract CreativeReparations {
    address public steward;

    struct Reparation {
        string studio;
        string apology;
        string blessing;
        uint256 timestamp;
    }

    Reparation[] public reparations;

    event ReparationLogged(string studio, string apology, string blessing);

    constructor() {
        steward = msg.sender;
    }

    function offerReparation(string memory studio, string memory apology, string memory blessing) public {
        require(msg.sender == steward, "Only steward may offer reparations");
        reparations.push(Reparation(studio, apology, blessing, block.timestamp));
        emit ReparationLogged(studio, apology, blessing);
    }

    function getReparation(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        Reparation memory r = reparations[index];
        return (r.studio, r.apology, r.blessing, r.timestamp);
    }

    function totalReparations() public view returns (uint256) {
        return reparations.length;
    }
}
