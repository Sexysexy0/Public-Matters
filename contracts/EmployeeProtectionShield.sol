pragma solidity ^0.8.0;

contract EmployeeProtectionShield {
    event ProtectionAlert(string employee, string issue);

    function fileComplaint(string memory employee, string memory issue) public {
        emit ProtectionAlert(employee, issue);
    }
}
