pragma solidity ^0.8.20;

contract HybridBridgeProtocol {
    address public admin;

    struct Bridge {
        string typeOf;       // e.g. hybrid-electric
        string share;        // e.g. 34.5%
        string role;         // e.g. consumer preference, transition technology
        uint256 timestamp;
    }

    Bridge[] public bridges;

    event BridgeLogged(string typeOf, string share, string role, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBridge(string calldata typeOf, string calldata share, string calldata role) external onlyAdmin {
        bridges.push(Bridge(typeOf, share, role, block.timestamp));
        emit BridgeLogged(typeOf, share, role, block.timestamp);
    }

    function totalBridges() external view returns (uint256) {
        return bridges.length;
    }
}
