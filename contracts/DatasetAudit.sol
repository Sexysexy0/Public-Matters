// contracts/DatasetAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DatasetAudit
 * @notice Tracks dataset integrity and piracy verification.
 */
contract DatasetAudit {
    address public admin;

    struct Dataset {
        string name;        // "SpotifyScrape"
        uint256 size;       // in terabytes
        string verdict;     // "Authentic", "Fake", "Partial"
        uint256 timestamp;
    }

    Dataset[] public datasets;

    event DatasetLogged(string name, uint256 size, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDataset(string calldata name, uint256 size, string calldata verdict) external onlyAdmin {
        datasets.push(Dataset(name, size, verdict, block.timestamp));
        emit DatasetLogged(name, size, verdict, block.timestamp);
    }

    function totalDatasets() external view returns (uint256) { return datasets.length; }

    function getDataset(uint256 id) external view returns (Dataset memory) {
        require(id < datasets.length, "Invalid id");
        return datasets[id];
    }
}
