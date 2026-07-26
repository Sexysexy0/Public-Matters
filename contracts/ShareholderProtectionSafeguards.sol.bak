// ShareholderProtectionSafeguards.sol
pragma solidity ^0.8.0;

contract ShareholderProtectionSafeguards {
    struct Stakeholder {
        bool isActive;
        uint256 lastInquiryTime;
        bool waitingForResponse;
    }

    mapping(address => Stakeholder) public registry;

    function logInquiry() public {
        registry[msg.sender].lastInquiryTime = block.timestamp;
        registry[msg.sender].waitingForResponse = true;
    }

    function triggerAutomaticExtension(address _stakeholder) public view returns (bool) {
        // Kung lumampas ng 4 hours na walang sagot, automatic extension of permits/deadlines
        if (registry[_stakeholder].waitingForResponse && block.timestamp > registry[_stakeholder].lastInquiryTime + 4 hours) {
            return true;
        }
        return false;
    }
}
