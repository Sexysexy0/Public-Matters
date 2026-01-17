pragma solidity ^0.8.20;

contract GigEconomyProtocol {
    address public admin;

    struct Gig {
        string role;         // e.g. nurse, VA, freelancer
        uint256 income;      // reported or comparative income
        uint256 timestamp;
    }

    Gig[] public gigs;

    event GigLogged(string role, uint256 income, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGig(string calldata role, uint256 income) external onlyAdmin {
        gigs.push(Gig(role, income, block.timestamp));
        emit GigLogged(role, income, block.timestamp);
    }

    function totalGigs() external view returns (uint256) {
        return gigs.length;
    }
}
