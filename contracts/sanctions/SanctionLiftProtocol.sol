contract SanctionLiftProtocol {
    address public iran;
    bool public peacePledge;
    bool public nuclearUseProhibited;

    event SanctionsLifted(address indexed steward);
    event PeacePledgeSigned(address indexed steward);

    function liftSanctions(address _iran) public {
        require(peacePledge == true, "Peace pledge required");
        require(nuclearUseProhibited == true, "Nuclear use must be renounced");
        iran = _iran;
        emit SanctionsLifted(_iran);
    }

    function signPeacePledge() public {
        peacePledge = true;
        nuclearUseProhibited = true;
        emit PeacePledgeSigned(msg.sender);
    }
}
