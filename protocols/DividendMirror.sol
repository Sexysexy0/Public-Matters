// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// DividendMirror: record dividends or rebates for premium members
contract DividendMirror {
    struct Dividend {
        uint256 id;
        address member;
        uint256 amount;
        string basisURI;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Dividend) public dividends;
    mapping(address => bool) public stewards;

    event DividendLogged(uint256 indexed id, address member, uint256 amount);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logDividend(address member, uint256 amount, string calldata basisURI) external {
        require(stewards[msg.sender], "Only steward");
        dividends[nextId] = Dividend(nextId, member, amount, basisURI, block.timestamp);
        emit DividendLogged(nextId, member, amount);
        nextId++;
    }
}
