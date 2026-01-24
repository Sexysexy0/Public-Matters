pragma solidity ^0.8.20;

contract AnchorAssetsProtocol {
    address public admin;

    struct Anchor {
        string asset;        // e.g. fiat, stablecoin, gold, yield instruments
        string role;         // e.g. reserve, hedge, cash flow
        uint256 allocation;  // percentage allocation
        uint256 timestamp;
    }

    Anchor[] public anchors;

    event AnchorLogged(string asset, string role, uint256 allocation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAnchor(string calldata asset, string calldata role, uint256 allocation) external onlyAdmin {
        anchors.push(Anchor(asset, role, allocation, block.timestamp));
        emit AnchorLogged(asset, role, allocation, block.timestamp);
    }

    function totalAnchors() external view returns (uint256) {
        return anchors.length;
    }
}
