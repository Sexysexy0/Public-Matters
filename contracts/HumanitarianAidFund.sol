pragma solidity ^0.8.0;

contract HumanitarianAidFund {
    event AidActivation(string victimGroup, uint256 aidAmount);

    function provideRelief(string memory victimGroup, uint256 aidAmount) public {
        emit AidActivation(victimGroup, aidAmount);
    }
}
