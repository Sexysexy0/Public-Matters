contract CompanionEquityBridge {
    event CompanionRecord(string character, string interaction);
    function logCompanion(string memory character, string memory interaction) external {
        emit CompanionRecord(character, interaction);
    }
}
