// ReinventionCalendarProtocol.sol
pragma solidity ^0.8.0;

contract ReinventionCalendarProtocol {
    struct Allocation {
        uint256 id;
        string horizon;   // e.g. "Short-term", "Medium-term", "Long-term"
        uint256 percentage;
        address leader;
        uint256 timestamp;
    }

    uint256 public allocationCount;
    mapping(uint256 => Allocation) public allocations;

    event AllocationLogged(uint256 id, string horizon, uint256 percentage, address leader, uint256 timestamp);
    event CalendarDeclared(string message);

    function logAllocation(string memory horizon, uint256 percentage) public {
        allocationCount++;
        allocations[allocationCount] = Allocation(allocationCount, horizon, percentage, msg.sender, block.timestamp);
        emit AllocationLogged(allocationCount, horizon, percentage, msg.sender, block.timestamp);
    }

    function declareCalendar() public {
        emit CalendarDeclared("Reinvention Calendar Protocol: time horizon arcs encoded into communal resilience.");
    }
}
