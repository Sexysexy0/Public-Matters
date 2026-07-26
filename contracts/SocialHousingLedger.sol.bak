// SocialHousingLedger.sol
pragma solidity ^0.8.0;

contract SocialHousingLedger {
    struct Beneficiary {
        string name;
        uint256 incomeBracket;
        bool hasUnit;
    }

    mapping(address => Beneficiary) public list;

    function allocateUnit(address _resident, uint256 _income) public {
        require(_income < 20000, "Income too high for social housing");
        require(!list[_resident].hasUnit, "Already has a unit");
        
        list[_resident] = Beneficiary("Resident_Name", _income, true);
    }
}
