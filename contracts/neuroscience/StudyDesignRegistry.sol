// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudyDesignRegistry {
    struct Study {
        bytes32 designHash; // Hash ng study design document
        bytes32 hypothesis; // Hash ng hypothesis
        uint256 sampleSize;
        uint256 registeredAt;
        address researcher;
        bool isRegistered;
    }

    mapping(bytes32 => Study) public studies; // studyId => Study
    bytes32[] public studyIds;

    event StudyRegistered(bytes32 indexed studyId, address indexed researcher);

    function registerStudy(
        bytes32 _studyId,
        bytes32 _designHash,
        bytes32 _hypothesis,
        uint256 _sampleSize
    ) external {
        require(!studies[_studyId].isRegistered, "Study already registered");
        studies[_studyId] = Study({
            designHash: _designHash,
            hypothesis: _hypothesis,
            sampleSize: _sampleSize,
            registeredAt: block.timestamp,
            researcher: msg.sender,
            isRegistered: true
        });
        studyIds.push(_studyId);
        emit StudyRegistered(_studyId, msg.sender);
    }

    function getStudy(bytes32 _studyId) external view returns (Study memory) {
        return studies[_studyId];
    }
}
