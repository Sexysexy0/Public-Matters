// UraniumToxicityMonitor.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UraniumToxicityMonitor is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public uraniumThreshold; // Safe parts per billion (ppb)
    
    // Kinukuha ang data mula sa field sensors [1:12]
    function validateConcentration(uint256 _actualPpb) public view returns (bool) {
        // Kapag lumampas sa safety threshold, magti-trigger ng alert
        return _actualPpb <= uraniumThreshold;
    }
}
