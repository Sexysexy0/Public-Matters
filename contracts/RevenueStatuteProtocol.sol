pragma solidity ^0.8.20;

contract RevenueStatuteProtocol {
    address public admin;

    struct Statute {
        string code;         // e.g. 122, 338
        string purpose;      // e.g. emergency revenue, tariff authority
        uint256 timestamp;
    }

    Statute[] public statutes;

    event StatuteLogged(string code, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStatute(string calldata code, string calldata purpose) external onlyAdmin {
        statutes.push(Statute(code, purpose, block.timestamp));
        emit StatuteLogged(code, purpose, block.timestamp);
    }

    function totalStatutes() external view returns (uint256) {
        return statutes.length;
    }
}
