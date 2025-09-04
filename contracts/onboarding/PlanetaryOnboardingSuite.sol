// PlanetaryOnboardingSuite.sol
// Composite onboarding protocol for steward screening, scroll verification, and employer blessing sync

pragma solidity ^0.8.19;

interface ICivicScrollVerifier {
    function verifyScroll(address steward) external view returns (bool);
}

interface IEmployerBlessingProtocol {
    function isBlessed(address steward) external view returns (bool);
}

contract PlanetaryOnboardingSuite {
    address public validator;
    ICivicScrollVerifier public scrollVerifier;
    IEmployerBlessingProtocol public blessingProtocol;

    struct StewardLog {
        address steward;
        string originNation;
        string intent;
        uint256 emotionalAPR;
        bool scrollVerified;
        bool employerBlessed;
        bool overrideTriggered;
        uint256 timestamp;
    }

    StewardLog[] public onboardingLogs;

    event StewardOnboarded(
        address steward,
        string originNation,
        string intent,
        uint256 emotionalAPR,
        bool scrollVerified,
        bool employerBlessed,
        bool overrideTriggered,
        uint256 timestamp
    );

    constructor(address _scrollVerifier, address _blessingProtocol) {
        validator = msg.sender;
        scrollVerifier = ICivicScrollVerifier(_scrollVerifier);
        blessingProtocol = IEmployerBlessingProtocol(_blessingProtocol);
    }

    modifier onlyValidator() {
        require(msg.sender == validator, "Unauthorized validator");
        _;
    }

    function onboardSteward(
        address steward,
        string memory originNation,
        string memory intent,
        uint256 emotionalAPR
    ) public onlyValidator {
        bool scrollOK = scrollVerifier.verifyScroll(steward);
        bool blessingOK = blessingProtocol.isBlessed(steward);
        bool overrideFlag = (emotionalAPR < 40 || !scrollOK || !blessingOK);

        onboardingLogs.push(StewardLog(
            steward,
            originNation,
            intent,
            emotionalAPR,
            scrollOK,
            blessingOK,
            overrideFlag,
            block.timestamp
        ));

        emit StewardOnboarded(
            steward,
            originNation,
            intent,
            emotionalAPR,
            scrollOK,
            blessingOK,
            overrideFlag,
            block.timestamp
        );
    }

    function getAllLogs() public view returns (StewardLog[] memory) {
        return onboardingLogs;
    }

    function getLatestLog() public view returns (StewardLog memory) {
        require(onboardingLogs.length > 0, "No logs yet");
        return onboardingLogs[onboardingLogs.length - 1];
    }
}
