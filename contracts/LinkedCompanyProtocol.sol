pragma solidity ^0.8.20;

contract LinkedCompanyProtocol {
    address public admin;

    struct Link {
        string congressman;  // e.g. Edwin Gardiola
        string company;      // e.g. family-owned contractor
        uint256 amount;      // e.g. 22000000000
        uint256 timestamp;
    }

    Link[] public links;

    event LinkLogged(string congressman, string company, uint256 amount, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLink(string calldata congressman, string calldata company, uint256 amount) external onlyAdmin {
        links.push(Link(congressman, company, amount, block.timestamp));
        emit LinkLogged(congressman, company, amount, block.timestamp);
    }

    function totalLinks() external view returns (uint256) {
        return links.length;
    }
}
