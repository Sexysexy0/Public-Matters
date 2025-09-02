// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ElectricityBlessingOracle {
    struct Household {
        address steward;
        uint256 monthlyKWh;
        bool isBlessed;
        uint256 emotionalAPR;
    }

    mapping(address => Household) public registry;
    uint256 public blessingThreshold = 135; // kWh
    address public barangayValidator;

    event BlessingGranted(address indexed steward, uint256 kWh, uint256 emotionalAPR);
    event BlessingRevoked(address indexed steward);

    modifier onlyValidator() {
        require(msg.sender == barangayValidator, "Not authorized");
        _;
    }

    constructor(address _validator) {
        barangayValidator = _validator;
    }

    function registerHousehold(address steward, uint256 monthlyKWh, uint256 emotionalAPR) external onlyValidator {
        bool eligible = monthlyKWh <= blessingThreshold;
        registry[steward] = Household(steward, monthlyKWh, eligible, emotionalAPR);

        if (eligible) {
            emit BlessingGranted(steward, monthlyKWh, emotionalAPR);
        } else {
            emit BlessingRevoked(steward);
        }
    }

    function updateThreshold(uint256 newThreshold) external onlyValidator {
        blessingThreshold = newThreshold;
    }

    function isBlessed(address steward) external view returns (bool) {
        return registry[steward].isBlessed;
    }
}
