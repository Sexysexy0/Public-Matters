pragma solidity ^0.8.20;

contract AllianceTrustProtocol {
    address public admin;

    struct Trust {
        string ally;         // e.g. NATO member, regional partner
        string measure;      // e.g. intelligence sharing, joint ops
        string status;       // e.g. high trust, strained
        uint256 timestamp;
    }

    Trust[] public trusts;

    event TrustLogged(string ally, string measure, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrust(string calldata ally, string calldata measure, string calldata status) external onlyAdmin {
        trusts.push(Trust(ally, measure, status, block.timestamp));
        emit TrustLogged(ally, measure, status, block.timestamp);
    }

    function totalTrusts() external view returns (uint256) {
        return trusts.length;
    }
}
