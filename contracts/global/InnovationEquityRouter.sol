// SPDX-License-Identifier: InnovationSanctum
pragma solidity ^0.8.19;

contract InnovationEquityRouter {
    struct InnovationSignal {
        string projectID;
        string innovationType;
        string kpiMetric;
        uint256 equityWeight;
        bool longTermAligned;
        string stewardNote;
    }

    mapping(string => InnovationSignal) public innovationRegistry;

    event ProjectTagged(string projectID, string innovationType);
    event AlignmentVerified(string projectID);

    function tagProject(string memory projectID, string memory innovationType, string memory kpiMetric, uint256 equityWeight, bool longTermAligned, string memory stewardNote) public {
        innovationRegistry[projectID] = InnovationSignal(projectID, innovationType, kpiMetric, equityWeight, longTermAligned, stewardNote);
        emit ProjectTagged(projectID, innovationType);
    }

    function verifyAlignment(string memory projectID) public {
        require(bytes(innovationRegistry[projectID].innovationType).length > 0, "Project not tagged");
        innovationRegistry[projectID].longTermAligned = true;
        emit AlignmentVerified(projectID);
    }

    function getInnovationStatus(string memory projectID) public view returns (InnovationSignal memory) {
        return innovationRegistry[projectID];
    }
}
