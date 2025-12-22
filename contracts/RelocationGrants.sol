// contracts/RelocationGrants.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RelocationGrants
 * @notice Logs grant support for relocated vendors (stipends, stall fit-outs, rent subsidies).
 */
contract RelocationGrants {
    address public admin;

    struct Grant {
        uint256 projectId;      // link to RelocationMarket project index
        address recipient;      // vendor wallet or coordinator wallet
        uint256 amount;         // support amount
        string purpose;         // "Stipend", "FitOut", "RentSubsidy"
        uint256 timestamp;
    }

    Grant[] public grants;
    mapping(uint256 => uint256) public totalByProject;

    event GrantLogged(uint256 indexed projectId, address indexed recipient, uint256 amount, string purpose, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logGrant(uint256 projectId, address recipient, uint256 amount, string calldata purpose) external onlyAdmin {
        grants.push(Grant(projectId, recipient, amount, purpose, block.timestamp));
        totalByProject[projectId] += amount;
        emit GrantLogged(projectId, recipient, amount, purpose, block.timestamp);
    }

    function totalGrants() external view returns (uint256) {
        return grants.length;
    }

    function getGrant(uint256 id) external view returns (Grant memory) {
        require(id < grants.length, "Invalid id");
        return grants[id];
    }

    function getTotalByProject(uint256 projectId) external view returns (uint256) {
        return totalByProject[projectId];
    }
}
