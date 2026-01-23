pragma solidity ^0.8.20;

contract ExecutiveTrustProtocol {
    address public admin;

    struct Trust {
        string administration; // e.g. Obama, Trump, Biden
        string level;          // e.g. high, low
        string consequence;    // e.g. autonomy, weakened agency
        uint256 timestamp;
    }

    Trust[] public trusts;

    event TrustLogged(string administration, string level, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrust(string calldata administration, string calldata level, string calldata consequence) external onlyAdmin {
        trusts.push(Trust(administration, level, consequence, block.timestamp));
        emit TrustLogged(administration, level, consequence, block.timestamp);
    }

    function totalTrusts() external view returns (uint256) {
        return trusts.length;
    }
}
