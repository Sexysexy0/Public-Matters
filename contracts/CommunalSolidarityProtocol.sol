pragma solidity ^0.8.20;

contract CommunalSolidarityProtocol {
    address public admin;

    struct Solidarity {
        string community;    // e.g. Palestinians, global allies
        string support;      // e.g. petitions, protests, advocacy
        uint256 timestamp;
    }

    Solidarity[] public solidarities;

    event SolidarityLogged(string community, string support, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSolidarity(string calldata community, string calldata support) external onlyAdmin {
        solidarities.push(Solidarity(community, support, block.timestamp));
        emit SolidarityLogged(community, support, block.timestamp);
    }

    function totalSolidarities() external view returns (uint256) {
        return solidarities.length;
    }
}
