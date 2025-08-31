contract DisabilityOverride {
    address public steward;
    mapping(address => bool) public isRestorationEligible;
    mapping(address => bool) public isEmergencyFlagged;

    event RestorationApproved(address indexed patient, string condition, uint256 timestamp);
    event EmergencyHealTriggered(address indexed patient, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized: Steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagEmergency(address patient, string memory reason) public onlySteward {
        isEmergencyFlagged[patient] = true;
        emit EmergencyHealTriggered(patient, reason);
    }

    function approveRestoration(address patient, string memory condition) public onlySteward {
        isRestorationEligible[patient] = true;
        emit RestorationApproved(patient, condition, block.timestamp);
    }

    function isEligible(address patient) public view returns (bool) {
        return isRestorationEligible[patient] || isEmergencyFlagged[patient];
    }
}
