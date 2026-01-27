pragma solidity ^0.8.20;

contract PACInfluenceProtocol {
    address public admin;

    struct PAC {
        string name;         // e.g. AI super PAC, Fairshake model
        string funder;       // e.g. major AI investors
        string target;       // e.g. legislators, bills
        uint256 timestamp;
    }

    PAC[] public pacs;

    event PACLogged(string name, string funder, string target, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPAC(string calldata name, string calldata funder, string calldata target) external onlyAdmin {
        pacs.push(PAC(name, funder, target, block.timestamp));
        emit PACLogged(name, funder, target, block.timestamp);
    }

    function totalPACs() external view returns (uint256) {
        return pacs.length;
    }
}
