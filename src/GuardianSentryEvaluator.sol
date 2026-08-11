// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GuardianSentryEvaluator {
    enum ImpactLevel {
        Neutral,
        Beneficial,
        Catastrophic,
        Transformative
    }

    struct Evaluation {
        string policyTitle;
        ImpactLevel predictedImpact;
        uint256 riskScore; // 0 to 100
        bool sentryApproved;
        bool evaluated;
        address monkEvaluator;
    }

    mapping(bytes32 => Evaluation) public sentryRecords;
    address public immutable watchTowerMonk;

    event SentryEvaluated(bytes32 indexed policyId, ImpactLevel impact, uint256 riskScore, bool approved);
    event AlarmTriggered(bytes32 indexed policyId, string warningMessage);

    modifier onlyMonk() {
        require(msg.sender == watchTowerMonk, "Unauthorized: Watch Tower Monk only");
        _;
    }

    constructor() {
        watchTowerMonk = msg.sender;
    }

    function evaluateRippleEffect(bytes32 _policyId, string memory _title, uint256 _riskScore, ImpactLevel _impact)
        external
        onlyMonk
        returns (bool)
    {
        require(!sentryRecords[_policyId].evaluated, "Already evaluated by Sentry");
        require(_riskScore <= 100, "Invalid risk score range");

        // The Monk's logic: If risk is too high or catastrophic, reject automatically to prevent bad ripples
        bool approved = true;
        string memory warning = "";

        if (_impact == ImpactLevel.Catastrophic || _riskScore > 75) {
            approved = false;
            warning = "CRITICAL WARNING: High risk of harmful ripple effect detected. Sentry Blocked.";
            emit AlarmTriggered(_policyId, warning);
        }

        sentryRecords[_policyId] = Evaluation({
            policyTitle: _title,
            predictedImpact: _impact,
            riskScore: _riskScore,
            sentryApproved: approved,
            evaluated: true,
            monkEvaluator: msg.sender
        });

        emit SentryEvaluated(_policyId, _impact, _riskScore, approved);
        return approved;
    }
}
