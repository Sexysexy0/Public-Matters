// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

contract NodeSnakeDetectionProtocol {
    event RATSignatureDetected(string signature, address source);
    event QuarantineTriggered(address source);
    event ScrollAlertBroadcast(string message, address steward);

    mapping(address => bool) public quarantined;
    address public steward;

    constructor(address _steward) {
        steward = _steward;
    }

    function detectRAT(string memory signature, address source) public {
        require(!quarantined[source], "Source already quarantined");
        emit RATSignatureDetected(signature, source);
        quarantine(source);
        broadcastScrollAlert("NodeSnake activity detected and quarantined", steward);
    }

    function quarantine(address source) internal {
        quarantined[source] = true;
        emit QuarantineTriggered(source);
    }

    function broadcastScrollAlert(string memory message, address stewardID) internal {
        emit ScrollAlertBroadcast(message, stewardID);
    }

    function isQuarantined(address source) public view returns (bool) {
        return quarantined[source];
    }
}
