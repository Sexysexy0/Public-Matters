pragma solidity ^0.8.20;

contract InstitutionalBastionProtocol {
    address public admin;

    struct Bastion {
        string institution;  // e.g. Ayala, BlackRock
        string asset;        // e.g. BTC, ETH, Gold
        string role;         // e.g. Holder, Accumulator
        uint256 timestamp;
    }

    Bastion[] public bastions;

    event BastionLogged(string institution, string asset, string role, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBastion(string calldata institution, string calldata asset, string calldata role) external onlyAdmin {
        bastions.push(Bastion(institution, asset, role, block.timestamp));
        emit BastionLogged(institution, asset, role, block.timestamp);
    }

    function totalBastions() external view returns (uint256) {
        return bastions.length;
    }
}
