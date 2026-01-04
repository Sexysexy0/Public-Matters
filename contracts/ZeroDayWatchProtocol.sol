pragma solidity ^0.8.20;

contract ZeroDayWatchProtocol {
    address public admin;

    struct ZeroDay {
        string cve;          // e.g. CVE-2025-12345
        string product;      // e.g. OS, browser, VPN
        string status;       // e.g. exploited, patched, monitoring
        uint256 timestamp;
    }

    ZeroDay[] public zeroDays;

    event ZeroDayLogged(string cve, string product, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logZeroDay(string calldata cve, string calldata product, string calldata status) external onlyAdmin {
        zeroDays.push(ZeroDay(cve, product, status, block.timestamp));
        emit ZeroDayLogged(cve, product, status, block.timestamp);
    }

    function totalZeroDays() external view returns (uint256) {
        return zeroDays.length;
    }
}
