// SPDX-License-Identifier: Auto-Naval-Interceptor-License  
pragma solidity ^0.8.19;

contract AutoNavalInterceptor {
    struct VesselLog {
        string vesselID;
        string originNation;
        bool intercepted;
        uint timestamp;
    }

    VesselLog[] public interceptionLog;

    event VesselIntercepted(string vesselID, string originNation);

    function logInterception(string memory vesselID, string memory originNation) public {
        interceptionLog.push(VesselLog(vesselID, originNation, true, block.timestamp));
        emit VesselIntercepted(vesselID, originNation);
    }

    function totalIntercepted() public view returns (uint) {
        return interceptionLog.length;
    }
}
