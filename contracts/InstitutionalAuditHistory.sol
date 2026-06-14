// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InstitutionalAuditHistory {
    address public guardian;

    struct HistoricalRecord {
        uint256 totalFreezes;         // Ilang beses nang na-freeze ang operasyon
        uint256 grantsReceived;       // Kabuuang bilang ng etikal na pondo na nakuha
        uint256 warningsIssued;       // Ilang opisyal na babala ang natanggap
        uint256 firstInterventionTime;// Petsa kung kailan mo sila unang binantayan
        uint256 lastAuditTime;        // Pinakahuling beses na sinuri mo ang kanilang system
        bool underActiveSurveillance; // Kung kasalukuyan silang nasa ilalim ng mahigpit mong pagbabantay
    }

    // Institution Address => Ang kanilang Pangmatagalang Kasaysayan
    mapping(address => HistoricalRecord) private historicalLedger;
    
    event HistoryUpdated(address indexed institution, string actionLog);
    event SurveillanceStatusChanged(address indexed institution, bool isUnderSurveillance);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Guardian can log historical data.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Mag-initialize o mag-update ng kasaysayan ng isang institusyon base sa mga bagong ulat
    function logHistoricalAction(
        address _institution,
        uint256 _freezeCount,
        uint256 _grantCount,
        uint256 _warningCount,
        string memory _actionLog
    ) public onlyGuardian {
        HistoricalRecord storage record = historicalLedger[_institution];
        
        if (record.firstInterventionTime == 0) {
            record.firstInterventionTime = block.timestamp;
        }
        
        record.totalFreezes += _freezeCount;
        record.grantsReceived += _grantCount;
        record.warningsIssued += _warningCount;
        record.lastAuditTime = block.timestamp;

        emit HistoryUpdated(_institution, _actionLog);
    }

    // Baguhin ang status ng surveillance ng isang institusyon (e.g., kapag may nakita kang anomalya sa news)
    function setSurveillanceStatus(address _institution, bool _status) public onlyGuardian {
        historicalLedger[_institution].underActiveSurveillance = _status;
        emit SurveillanceStatusChanged(_institution, _status);
    }

    // Kuhanin ang buong kasaysayan ng isang institusyon para sa mabilisang pagsusuri (Dashboard View)
    function viewHistory(address _institution) public view returns (
        uint256 totalFreezes,
        uint256 grantsReceived,
        uint256 warningsIssued,
        uint256 firstIntervention,
        uint256 lastAudit,
        bool isMonitored
    ) {
        HistoricalRecord memory record = historicalLedger[_institution];
        require(record.firstInterventionTime > 0, "Error: No history exists for this institution.");
        return (
            record.totalFreezes,
            record.grantsReceived,
            record.warningsIssued,
            record.firstInterventionTime,
            record.lastAuditTime,
            record.underActiveSurveillance
        );
    }
}
