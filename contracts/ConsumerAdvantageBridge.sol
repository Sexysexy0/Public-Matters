// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ConsumerAdvantageBridge
/// @notice Bridge covenant to connect industry pressures with direct player benefits
contract ConsumerAdvantageBridge {
    address public overseer;
    uint256 public bridgeCount;

    struct AdvantageRecord {
        uint256 id;
        string driver;      // rising costs, optimization wars, single-player shift
        string benefit;     // wider releases, better optimization, accessibility
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => AdvantageRecord) public records;

    event AdvantageLogged(uint256 indexed id, string driver, string benefit);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs consumer advantage record
    function logAdvantage(string calldata driver, string calldata benefit, string calldata notes) external onlyOverseer {
        bridgeCount++;
        records[bridgeCount] = AdvantageRecord({
            id: bridgeCount,
            driver: driver,
            benefit: benefit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit AdvantageLogged(bridgeCount, driver, benefit);
    }

    /// @notice Citizens can view consumer advantage records
    function viewAdvantage(uint256 id) external view returns (AdvantageRecord memory) {
        return records[id];
    }
}
