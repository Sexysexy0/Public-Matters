// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InstitutionalAuditHistory {
    address public guardian;
    
    struct HistoricalRecord {
        uint256 totalFreezes;         
        uint256 grantsReceived;       
        uint256 warningsIssued;       
        uint256 firstInterventionTime;
        uint256 lastAuditTime;        
        bool underActiveSurveillance; 
    }

    mapping(address => HistoricalRecord) private historicalLedger;
    // Address -> Kung awtorisado silang magrehistro ng logs (e.g., Sanctuary, Escrow)
    mapping(address => bool) public authorizedLoggers;

    event HistoryUpdated(address indexed institution, bytes32 actionLog);
    event SurveillanceStatusChanged(address indexed institution, bool isUnderSurveillance);
    event LoggerAuthorizationUpdated(address indexed logger, bool status);

    modifier onlyAuthorized() {
        require(msg.sender == guardian || authorizedLoggers[msg.sender], "Error: Access denied. Sender not authorized to log historical data.");
        _;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Access denied. Only the Sovereign Guardian can alter configurations.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Pormal na pagpapahintulot sa isang contract na mag-log ng kasaysayan
    function setLoggerAuthorization(address _logger, bool _status) public onlyGuardian {
        authorizedLoggers[_logger] = _status;
        emit LoggerAuthorizationUpdated(_logger, _status);
    }

    // Mag-initialize o mag-update ng kasaysayan (Cross-contract compatible & Gas Optimized)
    function logHistoricalAction(
        address _institution,
        uint256 _freezeCount,
        uint256 _grantCount,
        uint256 _warningCount,
        bytes32 _actionLog
    ) public onlyAuthorized {
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

    function setSurveillanceStatus(address _institution, bool _status) public onlyAuthorized {
        historicalLedger[_institution].underActiveSurveillance = _status;
        emit SurveillanceStatusChanged(_institution, _status);
    }

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
