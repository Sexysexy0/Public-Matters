// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PublicBenefitVisibility
/// @notice Covenant contract to show taxpayers how funds are allocated
contract PublicBenefitVisibility {
    address public owner;

    struct Allocation {
        string service;   // e.g. "Health", "Education", "Infrastructure"
        uint256 amount;   // allocated funds
    }

    mapping(string => Allocation) public allocations;
    string[] public services;

    event ServiceCreated(string service);
    event FundsAllocated(string service, uint256 amount);
    event ReportGenerated(string service, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createService(string memory service) public onlyOwner {
        allocations[service] = Allocation(service, 0);
        services.push(service);
        emit ServiceCreated(service);
    }

    function allocateFunds(string memory service, uint256 amount) public onlyOwner {
        require(bytes(allocations[service].service).length > 0, "Service not found");
        allocations[service].amount += amount;
        emit FundsAllocated(service, amount);
    }

    function generateReport(string memory service) public view returns (uint256) {
        return allocations[service].amount;
    }

    function listServices() public view returns (string[] memory) {
        return services;
    }
}
