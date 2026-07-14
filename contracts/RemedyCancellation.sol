// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RemedyCancellation
/// @notice Smart contract safeguard para sa true cancellation (asset burn + lift window)
contract RemedyCancellation {

    uint public constant LIFT_REQUEST_WINDOW = 90 days;

    struct Cancellation {
        uint domainId;
        uint cancelTime;
        bool burned;
        address lifter;
    }

    mapping(uint => Cancellation) public cancellations;
    address public admin;

    event DomainCancelled(uint indexed domainId, uint cancelTime);
    event DomainLiftRequested(uint indexed domainId, address indexed requester, uint requestTime);
    event DomainLifted(uint indexed domainId, address indexed lifter);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function cancelDomain(uint _domainId) public onlyAdmin {
        cancellations[_domainId] = Cancellation(_domainId, block.timestamp, true, address(0));
        emit DomainCancelled(_domainId, block.timestamp);
    }

    function requestLift(uint _domainId, address _requester) public onlyAdmin {
        Cancellation storage c = cancellations[_domainId];
        require(c.burned, "Domain not burned");
        require(block.timestamp <= c.cancelTime + LIFT_REQUEST_WINDOW, "Lift window expired");
        c.lifter = _requester;
        emit DomainLiftRequested(_domainId, _requester, block.timestamp);
    }

    function liftDomain(uint _domainId) public onlyAdmin {
        Cancellation storage c = cancellations[_domainId];
        require(c.burned, "Domain not burned");
        require(c.lifter != address(0), "No lift requested");
        c.burned = false;
        emit DomainLifted(_domainId, c.lifter);
        c.lifter = address(0); // Reset placeholder
    }
}
