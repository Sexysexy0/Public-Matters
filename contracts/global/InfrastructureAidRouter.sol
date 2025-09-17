// SPDX-License-Identifier: AidSanctum
pragma solidity ^0.8.19;

contract InfrastructureAidRouter {
    address public steward;

    struct AidDeployment {
        string country;
        string projectType;
        string contractor;
        uint256 budgetUSD;
        uint256 timestamp;
        bool verified;
    }

    AidDeployment[] public deployments;

    event AidLogged(string country, string projectType, string contractor, uint256 budgetUSD, uint256 timestamp);
    event AidVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logAidDeployment(
        string memory country,
        string memory projectType,
        string memory contractor,
        uint256 budgetUSD
    ) public {
        deployments.push(AidDeployment(country, projectType, contractor, budgetUSD, block.timestamp, false));
        emit AidLogged(country, projectType, contractor, budgetUSD, block.timestamp);
    }

    function verifyAidDeployment(uint256 index) public {
        require(index < deployments.length, "Invalid index");
        deployments[index].verified = true;
        emit AidVerified(index, msg.sender);
    }

    function getAidDeployment(uint256 index) public view returns (
        string memory, string memory, string memory, uint256, uint256, bool
    ) {
        AidDeployment memory a = deployments[index];
        return (a.country, a.projectType, a.contractor, a.budgetUSD, a.timestamp, a.verified);
    }

    function totalDeployments() public view returns (uint256) {
        return deployments.length;
    }
}
