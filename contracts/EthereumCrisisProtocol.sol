pragma solidity ^0.8.20;

contract EthereumCrisisProtocol {
    address public admin;

    struct Crisis {
        string issue;        // e.g. institutional midlife crisis, cheap gas scam
        string response;     // e.g. 35-point plan, governance reform
        uint256 timestamp;
    }

    Crisis[] public crises;

    event CrisisLogged(string issue, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCrisis(string calldata issue, string calldata response) external onlyAdmin {
        crises.push(Crisis(issue, response, block.timestamp));
        emit CrisisLogged(issue, response, block.timestamp);
    }

    function totalCrises() external view returns (uint256) {
        return crises.length;
    }
}
