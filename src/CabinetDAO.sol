// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {OperatorPrivileges} from "./OperatorPrivileges.sol";

contract CabinetDAO {
    OperatorPrivileges public immutable privileges;
    mapping(address => string) public ministers; 
    address[] public ministerList;

    event MinisterAppointed(address indexed minister, string role);
    event MinisterRemoved(address indexed minister);

    constructor(address _privilegesAddress) {
        privileges = OperatorPrivileges(_privilegesAddress);
    }

    modifier onlySystemAdmin() {
        require(privileges.isOperator(msg.sender), "Only enterprise system operator authorized");
        _;
    }

    function appointMinister(address _minister, string memory _role) public onlySystemAdmin {
        require(bytes(ministers[_minister]).length == 0, "Already appointed");
        ministers[_minister] = _role;
        ministerList.push(_minister);
        
        privileges.logAction(msg.sender, 10);
        emit MinisterAppointed(_minister, _role);
    }

    function removeMinister(address _minister) public onlySystemAdmin {
        require(bytes(ministers[_minister]).length > 0, "Not a minister");
        delete ministers[_minister];
        
        for (uint256 i = 0; i < ministerList.length; i++) {
            if (ministerList[i] == _minister) {
                ministerList[i] = ministerList[ministerList.length - 1];
                ministerList.pop();
                break;
            }
        }
        privileges.logAction(msg.sender, -5);
        emit MinisterRemoved(_minister);
    }

    function getMinisterRole(address _minister) public view returns (string memory) {
        return ministers[_minister];
    }

    function getAllMinisters() public view returns (address[] memory) {
        return ministerList;
    }
}
