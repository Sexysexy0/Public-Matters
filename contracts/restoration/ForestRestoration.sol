// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ForestRestoration {
    struct Steward {
        address stewardAddress;
        string region;
        uint256 treesPlanted;
        uint256 blessingsReceived;
        bool isActive;
    }

    mapping(address => Steward) public stewards;
    address public admin;
    uint256 public globalTreeCounter;
    uint256 public blessingRate = 0.01 ether; // Sahod per tree

    event TreePlanted(address indexed steward, string region, uint256 count);
    event BlessingReleased(address indexed steward, uint256 amount);
    event StewardJoined(address indexed steward, string region);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not scroll-certified");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function joinProgram(string memory _region) external {
        require(!stewards[msg.sender].isActive, "Already joined");
        stewards[msg.sender] = Steward(msg.sender, _region, 0, 0, true);
        emit StewardJoined(msg.sender, _region);
    }

    function plantTree(uint256 _count) external {
        require(stewards[msg.sender].isActive, "Not a steward");
        stewards[msg.sender].treesPlanted += _count;
        globalTreeCounter += _count;

        uint256 reward = _count * blessingRate;
        stewards[msg.sender].blessingsReceived += reward;
        payable(msg.sender).transfer(reward);

        emit TreePlanted(msg.sender, stewards[msg.sender].region, _count);
        emit BlessingReleased(msg.sender, reward);
    }

    function fundBlessings() external payable onlyAdmin {}

    function updateBlessingRate(uint256 _newRate) external onlyAdmin {
        blessingRate = _newRate;
    }

    function getStewardData(address _steward) external view returns (Steward memory) {
        return stewards[_steward];
    }
}
