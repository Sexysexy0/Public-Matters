// contracts/ChinaAscendancy.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChinaAscendancy
 * @notice Protocol for tracking China’s financial and geopolitical ascendancy.
 */
contract ChinaAscendancy {
    address public admin;

    struct AscendancyEvent {
        string initiative;   // e.g., "BRICS Fund", "Currency Shift"
        string description;
        uint256 value;
        uint256 timestamp;
    }

    AscendancyEvent[] public events;

    event AscendancyLogged(string initiative, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logAscendancy(string calldata initiative, string calldata description, uint256 value) external onlyAdmin {
        events.push(AscendancyEvent(initiative, description, value, block.timestamp));
        emit AscendancyLogged(initiative, description, value, block.timestamp);
    }

    function totalEvents() external view returns (uint256) {
        return events.length;
    }

    function getEvent(uint256 id) external view returns (AscendancyEvent memory) {
        require(id < events.length, "Invalid id");
        return events[id];
    }
}
