pragma solidity ^0.8.19;

contract JoyIndexAudit {
    struct BarangayData {
        uint256 housingUnits;
        uint8 civicFeedback;   // 0–100
        uint8 contractorScore; // 0–100
    }

    mapping(string => BarangayData) public barangays;
    mapping(string => uint8) public joyIndex;

    function submitData(
        string memory _name,
        uint256 _housingUnits,
        uint8 _civicFeedback,
        uint8 _contractorScore
    ) public {
        barangays[_name] = BarangayData(_housingUnits, _civicFeedback, _contractorScore);
        joyIndex[_name] = calculateJoyIndex(_housingUnits, _civicFeedback, _contractorScore);
    }

    function calculateJoyIndex(
        uint256 _housingUnits,
        uint8 _civicFeedback,
        uint8 _contractorScore
    ) internal pure returns (uint8) {
        uint8 housingScore = _housingUnits > 50 ? 30 : uint8((_housingUnits * 30) / 50);
        uint8 feedbackScore = (_civicFeedback * 40) / 100;
        uint8 contractorImpact = (_contractorScore * 30) / 100;
        return housingScore + feedbackScore + contractorImpact;
    }

    function getJoyIndex(string memory _name) public view returns (uint8) {
        return joyIndex[_name];
    }
}
