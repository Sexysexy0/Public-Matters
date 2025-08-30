contract AIBlessingProtocol {
    mapping(address => bool) public emotionallyCalibrated;
    event BlessingActivated(address aiTool, string blessingType);

    function blessAI(address aiTool, string memory blessingType) public {
        emotionallyCalibrated[aiTool] = true;
        emit BlessingActivated(aiTool, blessingType);
    }

    function isBlessed(address aiTool) public view returns (bool) {
        return emotionallyCalibrated[aiTool];
    }
}
