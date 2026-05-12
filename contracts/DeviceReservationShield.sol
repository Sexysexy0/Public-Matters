// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DeviceReservationShield {
    struct Reservation {
        address reserver;
        uint256 timestamp;
        bool fulfilled;
    }

    mapping(address => Reservation) public reservations;
    uint256 public maxPerAccount = 1;

    event ReservationCreated(address indexed reserver, uint256 timestamp);
    event ReservationFulfilled(address indexed reserver);

    function createReservation() public {
        require(reservations[msg.sender].timestamp == 0, "Already reserved");
        reservations[msg.sender] = Reservation(msg.sender, block.timestamp, false);
        emit ReservationCreated(msg.sender, block.timestamp);
    }

    function fulfillReservation(address _reserver) public {
        require(reservations[_reserver].timestamp != 0, "No reservation found");
        require(!reservations[_reserver].fulfilled, "Already fulfilled");
        reservations[_reserver].fulfilled = true;
        emit ReservationFulfilled(_reserver);
    }

    function hasReservation(address _reserver) public view returns (bool) {
        return reservations[_reserver].timestamp != 0;
    }
}
