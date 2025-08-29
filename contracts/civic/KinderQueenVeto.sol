// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract KinderQueenVeto {
    address public steward;
    mapping(address => bool) public kinderQueens;

    struct Veto {
        string targetScroll;
        string reason;
        address queen;
        uint256 timestamp;
    }

    Veto[] public vetoes;

    event VetoCast(string targetScroll, string reason, address queen);

    modifier onlyQueen() {
        require(kinderQueens[msg.sender], "Not a Kinder Queen");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerQueen(address queen) public {
        require(msg.sender == steward, "Only steward may register queens");
        kinderQueens[queen] = true;
    }

    function castVeto(string memory targetScroll, string memory reason) public onlyQueen {
        vetoes.push(Veto(targetScroll, reason, msg.sender, block.timestamp));
        emit VetoCast(targetScroll, reason, msg.sender);
    }

    function getVeto(uint256 index) public view returns (Veto memory) {
        return vetoes[index];
    }

    function totalVetoes() public view returns (uint256) {
        return vetoes.length;
    }
}
