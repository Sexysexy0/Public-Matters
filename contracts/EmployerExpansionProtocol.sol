pragma solidity ^0.8.20;

contract EmployerExpansionProtocol {
    address public admin;

    struct Expansion {
        string company;      // e.g. Manila-based employer
        string newRegion;    // e.g. Bulacan
        string wagePolicy;   // e.g. NCR rate applied
        uint256 timestamp;
    }

    Expansion[] public expansions;

    event ExpansionLogged(string company, string newRegion, string wagePolicy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExpansion(string calldata company, string calldata newRegion, string calldata wagePolicy) external onlyAdmin {
        expansions.push(Expansion(company, newRegion, wagePolicy, block.timestamp));
        emit ExpansionLogged(company, newRegion, wagePolicy, block.timestamp);
    }

    function totalExpansions() external view returns (uint256) {
        return expansions.length;
    }
}
