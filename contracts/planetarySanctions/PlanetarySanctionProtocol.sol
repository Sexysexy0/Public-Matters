contract PlanetarySanctionProtocol {
    address public aggressorState;
    bool public cashflowFrozen;
    bool public tradeSuspended;
    bool public gridAccessRevoked;

    event SanctionActivated(address indexed aggressor, string reason);
    event DamayClauseBroadcasted(string message);

    constructor(address _aggressorState) {
        aggressorState = _aggressorState;
    }

    function activateSanctions(string memory reason) public {
        cashflowFrozen = true;
        tradeSuspended = true;
        gridAccessRevoked = true;
        emit SanctionActivated(aggressorState, reason);
        emit DamayClauseBroadcasted("Civilians are protected. Restoration protocols activated.");
    }
}
