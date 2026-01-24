pragma solidity ^0.8.20;

contract BitcoinBuildupProtocol {
    address public admin;

    struct Buildup {
        string method;       // e.g. DCA, institutional mimicry, cold storage
        string source;       // e.g. reserves, rotation gains, yield funnel
        string safeguard;    // e.g. hardware wallet, multisig
        uint256 timestamp;
    }

    Buildup[] public buildups;

    event BuildupLogged(string method, string source, string safeguard, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBuildup(string calldata method, string calldata source, string calldata safeguard) external onlyAdmin {
        buildups.push(Buildup(method, source, safeguard, block.timestamp));
        emit BuildupLogged(method, source, safeguard, block.timestamp);
    }

    function totalBuildups() external view returns (uint256) {
        return buildups.length;
    }
}
