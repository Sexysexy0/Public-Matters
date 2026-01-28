pragma solidity ^0.8.20;

contract InvestorProtectionProtocol {
    address public admin;

    struct Protection {
        string issue;        // e.g. SEC crackdown, war on crypto
        string damage;       // e.g. multi-billion losses
        string remedy;       // e.g. CLARITY Act reforms
        uint256 timestamp;
    }

    Protection[] public protections;

    event ProtectionLogged(string issue, string damage, string remedy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logProtection(string calldata issue, string calldata damage, string calldata remedy) external onlyAdmin {
        protections.push(Protection(issue, damage, remedy, block.timestamp));
        emit ProtectionLogged(issue, damage, remedy, block.timestamp);
    }

    function totalProtections() external view returns (uint256) {
        return protections.length;
    }
}
