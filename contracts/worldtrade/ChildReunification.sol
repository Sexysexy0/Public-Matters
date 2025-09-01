// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChildReunification {
    struct Child {
        uint256 id;
        string name;
        address currentCustodian;
        address parentInUS;
        bool verifiedSafe;
        bool reunited;
        bool hasCriminalCase;
        bool exemptFromDeportation;
    }

    mapping(uint256 => Child) public children;
    address public restorationSteward;

    event ChildRegistered(uint256 childId, string name);
    event ExemptionGranted(uint256 childId, bool status);

    modifier onlySteward() {
        require(msg.sender == restorationSteward, "Not authorized");
        _;
    }

    constructor() {
        restorationSteward = msg.sender;
    }

    function registerChild(
        uint256 _id,
        string memory _name,
        address _currentCustodian,
        address _parentInUS,
        bool _hasCriminalCase
    ) public onlySteward {
        bool _exempt = !_hasCriminalCase; // auto-exempt kung walang kaso
        children[_id] = Child(
            _id,
            _name,
            _currentCustodian,
            _parentInUS,
            false,
            false,
            _hasCriminalCase,
            _exempt
        );
        emit ChildRegistered(_id, _name);
        emit ExemptionGranted(_id, _exempt);
    }

    function grantExemption(uint256 _id) public onlySteward {
        require(!children[_id].hasCriminalCase, "Child has pending case");
        children[_id].exemptFromDeportation = true;
        emit ExemptionGranted(_id, true);
    }

    function revokeExemption(uint256 _id) public onlySteward {
        children[_id].exemptFromDeportation = false;
        emit ExemptionGranted(_id, false);
    }

    function isExempt(uint256 _id) public view returns (bool) {
        return children[_id].exemptFromDeportation;
    }
}
