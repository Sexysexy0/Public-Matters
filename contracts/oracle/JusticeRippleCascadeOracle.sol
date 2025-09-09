// SPDX-License-Identifier: JusticeRipple-License
pragma solidity ^0.8.0;

contract JusticeRippleCascadeOracle {
    address public steward;

    struct Ripple {
        string reformClause;
        string verdictType;
        string civicDomain;
        uint256 timestamp;
    }

    Ripple[] public ripples;

    event JusticeRippleEmitted(string clause, string verdictType, string domain, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitRipple(string memory reformClause, string memory verdictType, string memory civicDomain) public {
        require(msg.sender == steward, "Only steward can emit");
        ripples.push(Ripple(reformClause, verdictType, civicDomain, block.timestamp));
        emit JusticeRippleEmitted(reformClause, verdictType, civicDomain, block.timestamp);
    }

    function getRipple(uint index) public view returns (string memory, string memory, string memory, uint256) {
        Ripple memory r = ripples[index];
        return (r.reformClause, r.verdictType, r.civicDomain, r.timestamp);
    }

    function totalRipples() public view returns (uint) {
        return ripples.length;
    }
}
