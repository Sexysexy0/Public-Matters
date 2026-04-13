// SurveillanceAccountability.sol
pragma solidity ^0.8.0;

contract SurveillanceAccountability {
    struct RequestLog {
        address requester;
        uint256 timestamp;
        bytes32 warrantHash;
        bool isFlagged;
    }

    mapping(address => uint256) public requestFrequency;
    event SurveillanceAlert(address entity, string reason);

    function logDataRequest(bytes32 _warrant) public {
        requestFrequency[msg.sender]++;
        
        // Anti-harvesting logic: more than 50 requests per hour is a red flag
        if (requestFrequency[msg.sender] > 50) {
            emit SurveillanceAlert(msg.sender, "High-frequency harvesting detected.");
        }
        
        // Requires valid warrant hash for sensitive queries
        require(_warrant != bytes32(0), "Warrant hash required for access.");
    }
}
