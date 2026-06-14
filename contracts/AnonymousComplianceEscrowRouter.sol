// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interface definitions para makausap ng Router ang mga nauna mong kontrata
interface IReputationSystem {
    function penalizeDemerit(address _institution, uint256 _points, string memory _reason) external;
}

interface IGracePeriod {
    function issueGracePeriod(address _institution, string memory _issueDescription, uint256 _durationInSeconds) external returns (uint256);
}

interface IAuditHistory {
    function logHistoricalAction(address _institution, uint256 _freezeCount, uint256 _grantCount, uint256 _warningCount, string memory _actionLog) external;
}

contract AutonomousComplianceEscrowRouter {
    address public guardian;

    // Mga address ng iyong mga naunang dineploy na kontrata
    address public reputationContract;
    address public gracePeriodContract;
    address public auditHistoryContract;

    event OrchestratedIntervention(address indexed institution, uint256 indexed gracePeriodId);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Router access denied. Only the Guardian can route workflows.");
        _;
    }

    constructor(address _reputation, address _gracePeriod, address _auditHistory) {
        guardian = msg.sender;
        reputationContract = _reputation;
        gracePeriodContract = _gracePeriod;
        auditHistoryContract = _auditHistory;
    }

    // Isang tawag mo lang dito bilang Guardian, gagawin na ng router ang tatlong magkakaibang aksyon sabay-sabay
    function executeIntervention(
        address _institution,
        uint256 _demeritPoints,
        string memory _reason,
        uint256 _graceDurationSeconds
    ) public onlyGuardian returns (uint256) {
        
        // 1. Awtomatikong magpataw ng demerit points sa reputasyon ng institusyon
        IRutationSystem(reputationContract).penalizeDemerit(_institution, _demeritPoints, _reason);

        // 2. Awtomatikong simulan ang countdown o grace period
        uint256 graceId = IGracePeriod(gracePeriodContract).issueGracePeriod(_institution, _reason, _graceDurationSeconds);

        // 3. Awtomatikong i-update ang pangmatagalang kasaysayan sa Archive dashboard
        IAuditHistory(auditHistoryContract).logHistoricalAction(
            _institution,
            0, // 0 muna sa freeze count
            0, // 0 muna sa grant count
            1, // Magdagdag ng 1 sa warning count
            string(abi.encodePacked("Router Intervention triggered. Reason: ", _reason))
        );

        emit OrchestratedIntervention(_institution, graceId);
        return graceId;
    }

    // Payagan ang Guardian na i-update ang mga address ng mga sub-contracts
    function updateContractAddresses(address _reputation, address _gracePeriod, address _auditHistory) public onlyGuardian {
        reputationContract = _reputation;
        gracePeriodContract = _gracePeriod;
        auditHistoryContract = _auditHistory;
    }
}
