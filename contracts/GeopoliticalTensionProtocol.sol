pragma solidity ^0.8.20;

contract GeopoliticalTensionProtocol {
    address public admin;

    struct Tension {
        string region;       // e.g. Ukraine, Middle East, China
        string issue;        // e.g. war, conflict, sanctions
        uint256 timestamp;
    }

    Tension[] public tensions;

    event TensionLogged(string region, string issue, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTension(string calldata region, string calldata issue) external onlyAdmin {
        tensions.push(Tension(region, issue, block.timestamp));
        emit TensionLogged(region, issue, block.timestamp);
    }

    function totalTensions() external view returns (uint256) {
        return tensions.length;
    }
}
