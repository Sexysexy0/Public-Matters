// ResultOwnershipRegistry.sol
// Logic: Performance over Loyalty
pragma solidity ^0.8.0;

contract ResultOwnershipRegistry {
    struct Result {
        string kpi;
        bool achieved;
        string feedback;
    }

    mapping(address => Result[]) public managerHistory;

    function logResult(address _manager, string memory _kpi, bool _status) public {
        // Goal: Accountability Transparency.
        // Nice managers focus on effort; Leaders focus on results.
        managerHistory[_manager].push(Result(_kpi, _status, "RESULT LOGGED"));
    }
}
