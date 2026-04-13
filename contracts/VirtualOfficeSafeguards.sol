// VirtualOfficeSafeguards.sol
pragma solidity ^0.8.0;

contract VirtualOfficeSafeguards {
    struct OfficerNode {
        address officer;
        bool isOnline;
        uint256 activeTickets;
        uint256 lastHeartbeat;
    }

    mapping(address => OfficerNode) public directory;

    function reportForDuty() public {
        // Digital attendance linked to WFH session
        directory[msg.sender].isOnline = true;
        directory[msg.sender].lastHeartbeat = block.timestamp;
    }

    function checkAvailability(address _officer) public view returns (bool) {
        // Session expires if no heartbeat in 30 minutes
        return (directory[_officer].isOnline && block.timestamp < directory[_officer].lastHeartbeat + 30 minutes);
    }
}
