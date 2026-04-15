pragma solidity ^0.8.0;

contract CitizenAuditApp {
    event Report(address indexed citizen, string project, string evidence);

    function submitReport(string memory _project, string memory _evidence) public {
        emit Report(msg.sender, _project, _evidence);
    }
}
