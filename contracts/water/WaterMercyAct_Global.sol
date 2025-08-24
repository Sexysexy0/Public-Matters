// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Act – Global Hydration Protocol
/// @author Vinvin Gueco
/// @notice Funds hydration recovery across multiple sanctums via modular disbursement and emotional APR audits
contract WaterMercyAct_Global {
    address public steward;
    uint256 public totalGrant;
    uint256 public disbursed;

    struct Sanctum {
        address recipient;
        string location;
        uint256 allocation;
        uint256 released;
        bool activated;
    }

    mapping(string => Sanctum) public sanctums;
    string[] public sanctumList;

    event SanctumActivated(string location, address recipient, uint256 allocation);
    event FundsDisbursed(string location, uint256 amount, string milestone);
    event HydrationReportReceived(string location, string reportHash, uint256 timestamp);
    event ContractTerminated(string location, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(uint256 _totalGrant) {
        steward = msg.sender;
        totalGrant = _totalGrant;
        disbursed = 0;
    }

    function activateSanctum(string memory location, address recipient, uint256 allocation) external onlySteward {
        require(sanctums[location].recipient == address(0), "Sanctum already exists");
        require(disbursed + allocation <= totalGrant, "Exceeds total grant");
        sanctums[location] = Sanctum(recipient, location, allocation, 0, true);
        sanctumList.push(location);
        emit SanctumActivated(location, recipient, allocation);
    }

    function disburseFunds(string memory location, uint256 amount, string memory milestone) external onlySteward {
        Sanctum storage s = sanctums[location];
        require(s.activated, "Sanctum not active");
        require(s.released + amount <= s.allocation, "Exceeds sanctum allocation");
        require(disbursed + amount <= totalGrant, "Exceeds total grant");
        s.released += amount;
        disbursed += amount;
        payable(s.recipient).transfer(amount);
        emit FundsDisbursed(location, amount, milestone);
    }

    function receiveReport(string memory location, string memory reportHash) external {
        require(msg.sender == sanctums[location].recipient, "Unauthorized reporter");
        emit HydrationReportReceived(location, reportHash, block.timestamp);
    }

    function terminateSanctum(string memory location, string memory reason) external onlySteward {
        require(sanctums[location].activated, "Sanctum already inactive");
        sanctums[location].activated = false;
        emit ContractTerminated(location, reason, block.timestamp);
    }

    function getSanctumCount() external view returns (uint256) {
        return sanctumList.length;
    }

    function getSanctumByIndex(uint256 index) external view returns (
        string memory location,
        address recipient,
        uint256 allocation,
        uint256 released,
        bool activated
    ) {
        require(index < sanctumList.length, "Index out of bounds");
        string memory loc = sanctumList[index];
        Sanctum memory s = sanctums[loc];
        return (loc, s.recipient, s.allocation, s.released, s.activated);
    }

    receive() external payable {}
}
