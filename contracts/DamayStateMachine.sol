// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DamayStateMachine {
    enum DamayPhase { None, Alert, Negotiation, Settlement, Recovery }
    struct ExchangeStatus {
        DamayPhase phase;
        uint256 assets;
        uint256 liabilities;
        bool insolvent;
    }

    mapping(address => ExchangeStatus) public exchanges;
    event DamayPhaseChanged(address indexed exchange, DamayPhase newPhase);
    event DamayTriggered(address indexed exchange, string message);

    modifier onlyInPhase(address exchange, DamayPhase required) {
        require(exchanges[exchange].phase == required, "Invalid phase");
        _;
    }

    function triggerAlert(address exchange, uint256 assets, uint256 liabilities) external {
        exchanges[exchange] = ExchangeStatus({
            phase: DamayPhase.Alert,
            assets: assets,
            liabilities: liabilities,
            insolvent: liabilities > assets
        });
        emit DamayPhaseChanged(exchange, DamayPhase.Alert);
        emit DamayTriggered(exchange, "Alert triggered: insolvency suspected");
    }

    function startNegotiation(address exchange)
        external
        onlyInPhase(exchange, DamayPhase.Alert)
    {
        exchanges[exchange].phase = DamayPhase.Negotiation;
        emit DamayPhaseChanged(exchange, DamayPhase.Negotiation);
    }

    function settle(address exchange)
        external
        onlyInPhase(exchange, DamayPhase.Negotiation)
    {
        exchanges[exchange].phase = DamayPhase.Settlement;
        emit DamayPhaseChanged(exchange, DamayPhase.Settlement);
    }

    function recover(address exchange)
        external
        onlyInPhase(exchange, DamayPhase.Settlement)
    {
        exchanges[exchange].phase = DamayPhase.Recovery;
        emit DamayPhaseChanged(exchange, DamayPhase.Recovery);
    }
}
