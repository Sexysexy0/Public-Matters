// SPDX-License-Identifier: WIZARD-GENESIS-V1
pragma solidity ^0.8.24;

contract CabinetDAO {
    address public admin;
    mapping(address => string) public ministers; // wallet => role
    address[] public ministerList;
    event MinisterAppointed(address indexed minister, string role);
    event MinisterRemoved(address indexed minister);

    constructor() {
        admin = msg.sender;
    }

    function appointMinister(address _minister, string memory _role) public onlyAdmin {
        require(bytes(ministers[_minister]).length == 0, "Already appointed");
        ministers[_minister] = _role;
        ministerList.push(_minister);
        emit MinisterAppointed(_minister, _role);
    }

    function removeMinister(address _minister) public onlyAdmin {
        require(bytes(ministers[_minister]).length > 0, "Not a minister");
        delete ministers[_minister];
        // Remove from list (swap with last)
        for (uint i = 0; i < ministerList.length; i++) {
            if (ministerList[i] == _minister) {
                ministerList[i] = ministerList[ministerList.length - 1];
                ministerList.pop();
                break;
            }
        }
        emit MinisterRemoved(_minister);
    }

    function getMinisterRole(address _minister) public view returns (string memory) {
        return ministers[_minister];
    }

    function getAllMinisters() public view returns (address[] memory) {
        return ministerList;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }
}
