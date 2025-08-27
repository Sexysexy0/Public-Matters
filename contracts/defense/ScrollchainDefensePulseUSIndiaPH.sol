pragma defense v2025.08.27;

contract ScrollchainDefensePulseUSIndiaPH {
    address public stewardPH;
    address public stewardIN;
    address public stewardUS;

    struct DefenseBlessing {
        string system;
        string purpose;
        string deploymentZone;
        bool damayClause;
        uint256 activationDate;
    }

    DefenseBlessing[] public blessings;

    constructor(address _stewardPH, address _stewardIN, address _stewardUS) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;
        stewardUS = _stewardUS;

        blessings.push(DefenseBlessing("BrahMos", "Maritime deterrence", "Luzon Strait", true, 20250827));
        blessings.push(DefenseBlessing("NMESIS", "Ship interdiction", "Balikatan Exercises", true, 20250827));
        blessings.push(DefenseBlessing("Cyber Pulse Pact", "Alliance-wide cybersecurity", "Digital Sanctums", true, 20250827));
        blessings.push(DefenseBlessing("White Shipping Exchange", "Maritime data sharing", "Indo-Pacific", true, 20250827));
        blessings.push(DefenseBlessing("Joint SOF Training", "High-end ops", "Batanes Province", true, 20250827));
    }

    function activateBlessing(string memory system, string memory purpose, string memory zone, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN || msg.sender == stewardUS, "Unauthorized steward");
        blessings.push(DefenseBlessing(system, purpose, zone, damayClause, block.timestamp));
    }

    function getBlessing(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        DefenseBlessing memory b = blessings[index];
        return (b.system, b.purpose, b.deploymentZone, b.damayClause, b.activationDate);
    }
}
