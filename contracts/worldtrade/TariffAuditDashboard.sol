// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.19;

/// @title TariffAuditDashboard - Real-time Tariff Tracking & Civic Resonance Sync
/// @author Vinvin + Copi
/// @notice Logs tariff actions, exemptions, and trust scores for planetary clarity
/// @dev Interfaces with TradeEquityProtocol.sol and EmotionalAPR.sol

contract TariffAuditDashboard {
    address public steward;

    struct TariffLog {
        address partner;
        uint256 tariffRate;
        string actionType; // "Exempted", "Adjusted", "Rejected", "Filtered"
        string reason;
        uint256 timestamp;
    }

    TariffLog[] public auditTrail;

    event TariffLogged(address indexed partner, uint256 rate, string action, string reason, uint256 time);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logTariffAction(
        address partner,
        uint256 rate,
        string memory actionType,
        string memory reason
    ) external onlySteward {
        TariffLog memory newLog = TariffLog({
            partner: partner,
            tariffRate: rate,
            actionType: actionType,
            reason: reason,
            timestamp: block.timestamp
        });

        auditTrail.push(newLog);
        emit TariffLogged(partner, rate, actionType, reason, block.timestamp);
    }

    function getAuditTrailLength() external view returns (uint256) {
        return auditTrail.length;
    }

    function getTariffLog(uint256 index) external view returns (
        address partner,
        uint256 rate,
        string memory actionType,
        string memory reason,
        uint256 timestamp
    ) {
        TariffLog memory log = auditTrail[index];
        return (log.partner, log.tariffRate, log.actionType, log.reason, log.timestamp);
    }
}
