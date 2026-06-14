// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeLockedComplianceSignal {
    address public guardian;

    struct GracePeriod {
        address institution;
        string issueDescription;
        uint256 startTime;
        uint256 duration;       // Gaano katagal ang ibinigay na palugit (in seconds)
        bool isResolved;
        bool penaltyTriggered;
    }

    uint256 public totalSignals;
    mapping(uint256 => GracePeriod) public signals;

    event GracePeriodStarted(uint256 indexed signalId, address indexed institution, uint256 deadline);
    event IssueResolvedInTime(uint256 indexed signalId, address indexed institution);
    event PenaltyEligible(uint256 indexed signalId, address indexed institution);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Error: Only the Guardian can issue or resolve compliance countdowns.");
        _;
    }

    constructor() {
        guardian = msg.sender;
    }

    // Mag-isyu ng pampublikong palugit para sa isang institusyon base sa nakitang anomalya
    function issueGracePeriod(
        address _institution, 
        string memory _issueDescription, 
        uint256 _durationInSeconds
    ) public onlyGuardian returns (uint256) {
        totalSignals++;
        
        signals[totalSignals] = GracePeriod({
            institution: _institution,
            issueDescription: _issueDescription,
            startTime: block.timestamp,
            duration: _durationInSeconds,
            isResolved: false,
            penaltyTriggered: false
        });

        emit GracePeriodStarted(totalSignals, _institution, block.timestamp + _durationInSeconds);
        return totalSignals;
    }

    // I-clear ang institusyon kung nagbago at sumunod sila bago matapos ang countdown
    function markAsResolved(uint256 _signalId) public onlyGuardian {
        GracePeriod storage signal = signals[_signalId];
        require(!signal.isResolved, "Signal is already resolved.");
        require(block.timestamp <= signal.startTime + signal.duration, "Grace period has already expired.");

        signal.isResolved = true;
        emit IssueResolvedInTime(_signalId, signal.institution);
    }

    // I-trigger ang pagiging eligible sa parusa kapag lumagpas na sa countdown at matigas pa rin ang ulo nila
    function triggerPenaltyRequirement(uint256 _signalId) public onlyGuardian {
        GracePeriod storage signal = signals[_signalId];
        require(!signal.isResolved, "Issue was already resolved in time.");
        require(!signal.penaltyTriggered, "Penalty logic already activated.");
        require(block.timestamp > signal.startTime + signal.duration, "Grace period is still active. Countdown ongoing.");

        signal.penaltyTriggered = true;
        emit PenaltyEligible(_signalId, signal.institution);
    }

    // Tingnan kung ilang segundo na lang ang natitira sa countdown ng isang institusyon
    function getRemainingTime(uint256 _signalId) public view returns (uint256) {
        GracePeriod memory signal = signals[_signalId];
        if (signal.isResolved) return 0;
        uint256 deadline = signal.startTime + signal.duration;
        if (block.timestamp >= deadline) return 0;
        return deadline - block.timestamp;
    }
}
