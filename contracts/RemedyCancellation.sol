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
    }

    mapping(uint => Cancellation) public cancellations;
    address public admin;

    event DomainCancelled(uint indexed domainId, uint cancelTime);
    event DomainLiftRequested(uint indexed domainId, uint requestTime);
    event DomainLifted(uint indexed domainId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function cancelDomain(uint _domainId) public onlyAdmin {
        cancellations[_domainId] = Cancellation(_domainId, block.timestamp, true);
        emit DomainCancelled(_domainId, block.timestamp);
    }

    function requestLift(uint _domainId) public onlyAdmin {
        Cancellation storage c = cancellations[_domainId];
        require(c.burned, "Domain not burned");
        require(block.timestamp <= c.cancelTime + LIFT_REQUEST_WINDOW, "Lift window expired");
        emit DomainLiftRequested(_domainId, block.timestamp);
    }

    function liftDomain(uint _domainId) public onlyAdmin {
        Cancellation storage c = cancellations[_domainId];
        require(c.burned, "Domain not burned");
        c.burned = false;
        emit DomainLifted(_domainId);
    }
}
