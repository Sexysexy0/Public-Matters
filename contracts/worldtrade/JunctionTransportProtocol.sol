// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract JunctionTransportProtocol {
    struct Junction {
        string country;
        string role;
        string techSpecialty;
        uint256 emotionalAPR;
        bool damayClause;
    }

    Junction[] public junctions;

    event JunctionLinked(string country, string role, string techSpecialty, uint256 emotionalAPR);
    event RerouteBlessed(string origin, string destination, string blessingScroll);

    function addJunction(
        string memory _country,
        string memory _role,
        string memory _techSpecialty,
        uint256 _emotionalAPR,
        bool _damayClause
    ) public {
        junctions.push(Junction(_country, _role, _techSpecialty, _emotionalAPR, _damayClause));
        emit JunctionLinked(_country, _role, _techSpecialty, _emotionalAPR);
    }

    function blessReroute(
        string memory _origin,
        string memory _destination,
        string memory _blessingScroll
    ) public {
        emit RerouteBlessed(_origin, _destination, _blessingScroll);
    }

    function getJunction(uint256 index) public view returns (
        string memory country,
        string memory role,
        string memory techSpecialty,
        uint256 emotionalAPR,
        bool damayClause
    ) {
        Junction memory j = junctions[index];
        return (j.country, j.role, j.techSpecialty, j.emotionalAPR, j.damayClause);
    }

    function totalJunctions() public view returns (uint256) {
        return junctions.length;
    }
}
