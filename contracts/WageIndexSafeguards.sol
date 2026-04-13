// WageIndexSafeguards.sol
pragma solidity ^0.8.0;

contract WageIndexSafeguards {
    struct WageStandard {
        uint256 baseWage;
        uint256 inflationMarkup; // Basis points (100 = 1%)
        uint256 lastUpdate;
    }

    mapping(string => WageStandard) public sectorWages;

    function adjustWage(string memory _sector, uint256 _inflation) public {
        // Increases base wage suggestion if inflation exceeds 3%
        uint256 markup = 0;
        if (_inflation > 300) {
            markup = _inflation;
        }
        sectorWages[_sector] = WageStandard(sectorWages[_sector].baseWage, markup, block.timestamp);
    }

    function getAdjustedWage(string memory _sector) public view returns (uint256) {
        WageStandard memory ws = sectorWages[_sector];
        return ws.baseWage + (ws.baseWage * ws.inflationMarkup / 10000);
    }
}
