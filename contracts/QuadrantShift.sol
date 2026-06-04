// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title QuadrantShift
/// @notice Covenant contract to encode shift from Employee/Self-Employed to Business Owner/Investor using AI leverage
contract QuadrantShift {
    address public owner;

    struct Shift {
        string fromQuadrant;   // e.g. "Employee", "Self-Employed"
        string toQuadrant;     // e.g. "Business Owner", "Investor"
        string mechanism;      // e.g. "AI Leverage", "Asset Ownership", "Cashflow Network"
        uint256 valueShift;    // placeholder for wealth or productivity shift
        uint256 timestamp;
    }

    Shift[] public shifts;

    event ShiftLogged(string fromQuadrant, string toQuadrant, string mechanism, uint256 valueShift, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new quadrant shift
    function logShift(string memory fromQuadrant, string memory toQuadrant, string memory mechanism, uint256 valueShift) public onlyOwner {
        Shift memory newShift = Shift(fromQuadrant, toQuadrant, mechanism, valueShift, block.timestamp);
        shifts.push(newShift);
        emit ShiftLogged(fromQuadrant, toQuadrant, mechanism, valueShift, block.timestamp);
    }

    function getShift(uint256 index) public view returns (string memory, string memory, string memory, uint256, uint256) {
        Shift memory s = shifts[index];
        return (s.fromQuadrant, s.toQuadrant, s.mechanism, s.valueShift, s.timestamp);
    }

    function getShiftCount() public view returns (uint256) {
        return shifts.length;
    }
}
