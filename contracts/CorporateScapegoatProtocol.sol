pragma solidity ^0.8.20;

contract CorporateScapegoatProtocol {
    address public admin;

    struct Scapegoat {
        string company;      // e.g. insurer, retailer
        string excuse;       // e.g. AI bug, denial of claim
        string consequence;  // e.g. consumer harm, corporate greed
        uint256 timestamp;
    }

    Scapegoat[] public scapegoats;

    event ScapegoatLogged(string company, string excuse, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logScapegoat(string calldata company, string calldata excuse, string calldata consequence) external onlyAdmin {
        scapegoats.push(Scapegoat(company, excuse, consequence, block.timestamp));
        emit ScapegoatLogged(company, excuse, consequence, block.timestamp);
    }

    function totalScapegoats() external view returns (uint256) {
        return scapegoats.length;
    }
}
