// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DamaySupport {
    struct Family {
        address wallet;
        string name;
        string location;
        bool verifiedLoss;
        bool needsWork;
        uint256 aidAmount;
        bool supported;
    }

    mapping(address => Family) public families;
    address public steward;
    uint256 public defaultAid = 0.1 ether;

    event FamilyVerified(address wallet, string name, string location);
    event AidReleased(address wallet, uint256 amount);
    event WorkOffered(address wallet);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function verifyFamily(address _wallet, string memory _name, string memory _location, bool _needsWork) external onlySteward {
        families[_wallet] = Family(_wallet, _name, _location, true, _needsWork, defaultAid, false);
        emit FamilyVerified(_wallet, _name, _location);
    }

    function releaseAid(address _wallet) external onlySteward {
        Family storage f = families[_wallet];
        require(f.verifiedLoss && !f.supported, "Already supported or not verified");
        f.supported = true;
        payable(_wallet).transfer(f.aidAmount);
        emit AidReleased(_wallet, f.aidAmount);
    }

    function offerWork(address _wallet) external onlySteward {
        require(families[_wallet].needsWork, "Work not requested");
        emit WorkOffered(_wallet);
    }

    function fundPool() external payable onlySteward {}

    function updateAidAmount(uint256 _newAmount) external onlySteward {
        defaultAid = _newAmount;
    }
}
