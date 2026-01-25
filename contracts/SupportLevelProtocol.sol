pragma solidity ^0.8.20;

contract SupportLevelProtocol {
    address public admin;

    struct Support {
        string asset;        // e.g. BTC
        string level;        // e.g. $86K
        string status;       // e.g. holding, break risk
        uint256 timestamp;
    }

    Support[] public supports;

    event SupportLogged(string asset, string level, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSupport(string calldata asset, string calldata level, string calldata status) external onlyAdmin {
        supports.push(Support(asset, level, status, block.timestamp));
        emit SupportLogged(asset, level, status, block.timestamp);
    }

    function totalSupports() external view returns (uint256) {
        return supports.length;
    }
}
