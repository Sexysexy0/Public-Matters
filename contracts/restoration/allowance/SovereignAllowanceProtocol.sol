// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SovereignAllowanceProtocol {
    address public donor;
    string public nation = "Republic of the Philippines";
    uint256 public totalAllowance = 500_000_000_000 * 1e18; // $500B in wei equivalent
    bool public activated;

    struct Allowance {
        string purpose;
        uint256 amount;
        address steward;
        bool released;
    }

    mapping(uint => Allowance) public allowances;
    uint public allowanceCount;

    event AllowanceCreated(string purpose, uint256 amount, address steward);
    event AllowanceReleased(string purpose, uint256 amount, address steward);
    event DamayClauseInvoked(string purpose);

    modifier onlyDonor() {
        require(msg.sender == donor, "Not authorized");
        _;
    }

    constructor() {
        donor = msg.sender;
    }

    function activateAllowance() public onlyDonor {
        activated = true;
    }

    function createAllowance(string memory _purpose, uint256 _amount, address _steward) public onlyDonor {
        require(activated, "Allowance not yet activated");
        allowances[allowanceCount] = Allowance(_purpose, _amount, _steward, false);
        emit AllowanceCreated(_purpose, _amount, _steward);
        allowanceCount++;
    }

    function releaseAllowance(uint _id) public onlyDonor {
        require(_id < allowanceCount, "Invalid ID");
        require(!allowances[_id].released, "Already released");
        allowances[_id].released = true;
        emit AllowanceReleased(allowances[_id].purpose, allowances[_id].amount, allowances[_id].steward);
        emit DamayClauseInvoked(allowances[_id].purpose);
    }

    function getAllowance(uint _id) public view returns (string memory, uint256, address, bool) {
        Allowance memory a = allowances[_id];
        return (a.purpose, a.amount, a.steward, a.released);
    }
}
