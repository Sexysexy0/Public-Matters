// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DamayAuditTrail {
    struct RestorationEvent {
        string sector;
        address steward;
        uint256 emotionalAPR;
        uint256 timestamp;
        string blessingSource;
    }

    RestorationEvent[] public events;
    address public validator;

    event RestorationLogged(string sector, address steward, uint256 emotionalAPR, string blessingSource);

    modifier onlyValidator() {
        require(msg.sender == validator, "Unauthorized validator");
        _;
    }

    constructor(address _validator) {
        validator = _validator;
    }

    function logRestoration(
        string memory sector,
        address steward,
        uint256 emotionalAPR,
        string memory blessingSource
    ) public onlyValidator {
        events.push(RestorationEvent(sector, steward, emotionalAPR, block.timestamp, blessingSource));
        emit RestorationLogged(sector, steward, emotionalAPR, blessingSource);
    }

    function getLatestEvent() public view returns (RestorationEvent memory) {
        require(events.length > 0, "No events yet");
        return events[events.length - 1];
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
