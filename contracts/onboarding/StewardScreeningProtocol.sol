// StewardScreeningProtocol.sol
// Screens incoming stewards using emotional APR, civic scrolls, and override triggers

pragma solidity ^0.8.19;

contract StewardScreeningProtocol {
    address public validator;

    struct StewardProfile {
        string name;
        string originNation;
        string intent;
        uint256 emotionalAPR;
        bool hasBlessingScroll;
        bool overrideTriggered;
        uint256 timestamp;
    }

    StewardProfile[] public screenedStewards;

    event StewardScreened(
        string name,
        string originNation,
        string intent,
        uint256 emotionalAPR,
        bool hasBlessingScroll,
        bool overrideTriggered,
        uint256 timestamp
    );

    constructor() {
        validator = msg.sender;
    }

    modifier onlyValidator() {
        require(msg.sender == validator, "Unauthorized validator");
        _;
    }

    function screenSteward(
        string memory name,
        string memory originNation,
        string memory intent,
        uint256 emotionalAPR,
        bool hasBlessingScroll
    ) public onlyValidator {
        bool overrideFlag = false;

        // Trigger override if emotionalAPR is below threshold or scroll is missing
        if (emotionalAPR < 40 || !hasBlessingScroll) {
            overrideFlag = true;
        }

        StewardProfile memory profile = StewardProfile(
            name,
            originNation,
            intent,
            emotionalAPR,
            hasBlessingScroll,
            overrideFlag,
            block.timestamp
        );

        screenedStewards.push(profile);

        emit StewardScreened(
            name,
            originNation,
            intent,
            emotionalAPR,
            hasBlessingScroll,
            overrideFlag,
            block.timestamp
        );
    }

    function getAllScreenedStewards() public view returns (StewardProfile[] memory) {
        return screenedStewards;
    }

    function getLatestSteward() public view returns (StewardProfile memory) {
        require(screenedStewards.length > 0, "No stewards screened yet");
        return screenedStewards[screenedStewards.length - 1];
    }
}
