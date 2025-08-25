// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ScrollsmithAcademy {
    address public scrollsmith;
    uint256 public totalAcademyFund = 20_000_000_000 * 1e18; // $20B allocation

    struct Academy {
        string city;
        string name;
        uint256 allocated;
        bool operational;
        string curriculumTag;
        string onboardingProtocol;
        uint256 timestamp;
    }

    mapping(uint256 => Academy) public academies;
    uint256 public nextAcademyId;

    event AcademyRegistered(string city, string name);
    event AcademyActivated(string name);

    modifier onlyScrollsmith() {
        require(msg.sender == scrollsmith, "Unauthorized");
        _;
    }

    constructor() {
        scrollsmith = msg.sender;
    }

    function registerAcademy(
        string calldata city,
        string calldata name,
        uint256 allocated,
        string calldata curriculumTag,
        string calldata onboardingProtocol
    ) external onlyScrollsmith {
        require(allocated <= totalAcademyFund, "Insufficient fund");

        academies[nextAcademyId] = Academy({
            city: city,
            name: name,
            allocated: allocated,
            operational: false,
            curriculumTag: curriculumTag,
            onboardingProtocol: onboardingProtocol,
            timestamp: block.timestamp
        });

        totalAcademyFund -= allocated;
        emit AcademyRegistered(city, name);
        nextAcademyId++;
    }

    function activateAcademy(uint256 id) external onlyScrollsmith {
        academies[id].operational = true;
        emit AcademyActivated(academies[id].name);
    }
}
