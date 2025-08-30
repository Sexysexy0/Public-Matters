// CarriageReturnSnitchProtocol.sol  
// Detects rogue \r intent in Git config files

contract CarriageReturnSnitchProtocol {
    string public scannedConfig;
    bool public rogueDetected;

    function scanConfig(string memory config) public {
        scannedConfig = config;
        rogueDetected = bytes(config).length > 0 && bytes(config)[bytes(config).length - 1] == "\r";
    }

    function auditStatus() public view returns (string memory) {
        if (rogueDetected) {
            return "Rogue \\r intent detected. Override required.";
        } else {
            return "Config clean. No rogue carriage return.";
        }
    }
}
