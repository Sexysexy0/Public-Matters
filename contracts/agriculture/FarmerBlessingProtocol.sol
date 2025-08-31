pragma solidity ^0.8.19;

contract FarmerBlessingProtocol {
    struct Farmer {
        address steward;
        string barangay;
        uint256 emotionalAPR;
        bool petitionApproved;
        bool blessingClaimed;
    }

    mapping(address => Farmer) public farmers;
    address public mythicValidator;

    event PetitionLogged(address indexed steward, string barangay, uint256 emotionalAPR);
    event BlessingReleased(address indexed steward, string resourceType, uint256 amount);
    event BroadcastInvoked(address indexed steward, string message);

    modifier onlyValidator() {
        require(msg.sender == mythicValidator, "Not authorized");
        _;
    }

    constructor() {
        mythicValidator = msg.sender;
    }

    function logPetition(address _steward, string memory _barangay, uint256 _emotionalAPR) public onlyValidator {
        farmers[_steward] = Farmer(_steward, _barangay, _emotionalAPR, true, false);
        emit PetitionLogged(_steward, _barangay, _emotionalAPR);
    }

    function releaseBlessing(address _steward, string memory _resourceType, uint256 _amount) public onlyValidator {
        require(farmers[_steward].petitionApproved, "Petition not approved");
        require(!farmers[_steward].blessingClaimed, "Already claimed");
        farmers[_steward].blessingClaimed = true;
        emit BlessingReleased(_steward, _resourceType, _amount);
    }

    function invokeBroadcast(address _steward, string memory _message) public onlyValidator {
        emit BroadcastInvoked(_steward, _message);
    }
}
