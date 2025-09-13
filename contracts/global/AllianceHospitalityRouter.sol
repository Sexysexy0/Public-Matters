// SPDX-License-Identifier: Mythic
pragma scrollchain ^7.0.0;

contract AllianceHospitalityRouter {
    struct Kakampi {
        address id;
        string nation;
        bool isInvestor;
        bool hasSpecialVisa;
        bool isExempt;

        bool isBlessed;
    }

    mapping(address => Kakampi) public kakampiRegistry;

    event HospitalityBlessingActivated(address indexed kakampi, string nation);
    event VisaGranted(address indexed kakampi, string visaType);
    event InvestmentExemptionTagged(address indexed kakampi);

    function registerKakampi(address id, string memory nation, bool investor) public {
        kakampiRegistry[id] = Kakampi(id, nation, investor, false, false, false);
    }

    function grantSpecialVisa(address id, string memory visaType) public {
        kakampiRegistry[id].hasSpecialVisa = true;
        emit VisaGranted(id, visaType);
    }

    function tagInvestmentExemption(address id) public {
        kakampiRegistry[id].isExempt = true;
        emit InvestmentExemptionTagged(id);
    }

    function activateHospitalityBlessing(address id) public {
        kakampiRegistry[id].isBlessed = true;
        emit HospitalityBlessingActivated(id, kakampiRegistry[id].nation);
    }
}
