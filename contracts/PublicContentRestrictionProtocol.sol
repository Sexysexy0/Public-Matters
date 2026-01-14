pragma solidity ^0.8.20;

contract PublicContentRestrictionProtocol {
    address public admin;

    struct Restriction {
        string content;      // e.g. explicit nude, vulgar post
        string reason;       // e.g. unsafe, dignity violation
        uint256 timestamp;
    }

    Restriction[] public restrictions;

    event RestrictionLogged(string content, string reason, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRestriction(string calldata content, string calldata reason) external onlyAdmin {
        restrictions.push(Restriction(content, reason, block.timestamp));
        emit RestrictionLogged(content, reason, block.timestamp);
    }

    function totalRestrictions() external view returns (uint256) {
        return restrictions.length;
    }
}
