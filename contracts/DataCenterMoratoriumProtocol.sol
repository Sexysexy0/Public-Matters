pragma solidity ^0.8.20;

contract DataCenterMoratoriumProtocol {
    address public admin;

    struct Freeze {
        string project;      // e.g. AI data center, cloud expansion
        string reason;       // e.g. resource shortage, communal priority
        uint256 timestamp;
    }

    Freeze[] public freezes;

    event FreezeLogged(string project, string reason, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFreeze(string calldata project, string calldata reason) external onlyAdmin {
        freezes.push(Freeze(project, reason, block.timestamp));
        emit FreezeLogged(project, reason, block.timestamp);
    }

    function totalFreezes() external view returns (uint256) {
        return freezes.length;
    }
}
