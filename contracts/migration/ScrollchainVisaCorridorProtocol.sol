pragma migration v2025.08.27;

contract ScrollchainVisaCorridorProtocol {
    address public stewardPH;
    address public stewardIN;
    address public stewardUS;

    struct VisaBlessing {
        string travelerType;
        string originCountry;
        string destinationCountry;
        string visaType;
        uint256 durationDays;
        bool damayClause;
    }

    VisaBlessing[] public blessings;

    constructor(address _stewardPH, address _stewardIN, address _stewardUS) {
        stewardPH = _stewardPH;
        stewardIN = _stewardIN;
        stewardUS = _stewardUS;

        blessings.push(VisaBlessing("Tourist", "India", "Philippines", "Visa-Free", 14, true));
        blessings.push(VisaBlessing("Tourist", "India (AJACSSUK holders)", "Philippines", "Visa-Free", 30, true));
        blessings.push(VisaBlessing("Filipino Citizen", "Philippines", "India", "Free e-Visa", 30, true));
        blessings.push(VisaBlessing("Student", "India", "Philippines", "e-Visa", 180, true));
        blessings.push(VisaBlessing("Business Delegate", "US", "India", "Fast-Track Visa", 90, true));
        blessings.push(VisaBlessing("Cultural Envoy", "Philippines", "US", "Kinder Exchange Visa", 60, true));
    }

    function activateBlessing(string memory travelerType, string memory origin, string memory destination, string memory visaType, uint256 durationDays, bool damayClause) public {
        require(msg.sender == stewardPH || msg.sender == stewardIN || msg.sender == stewardUS, "Unauthorized steward");
        blessings.push(VisaBlessing(travelerType, origin, destination, visaType, durationDays, damayClause));
    }

    function getBlessing(uint index) public view returns (string memory, string memory, string memory, string memory, uint256, bool) {
        VisaBlessing memory b = blessings[index];
        return (b.travelerType, b.originCountry, b.destinationCountry, b.visaType, b.durationDays, b.damayClause);
    }
}
