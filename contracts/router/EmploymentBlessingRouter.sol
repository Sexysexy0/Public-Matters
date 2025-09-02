contract EmploymentBlessingRouter {
    struct JobProgram {
        string name;
        string sector;
        uint256 aprScore;
        bool barangayBlessed;
        bool overrideReady;
    }

    mapping(address => JobProgram[]) public stewardPrograms;

    function blessProgram(address steward, string memory name, string memory sector, uint256 aprScore) public {
        stewardPrograms[steward].push(JobProgram(name, sector, aprScore, true, true));
    }
}
