// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RepresentationProtocol
 * @dev Secure Retainer and Milestone-Based Legal Engagement for OPC/Majority Shareholders.
 * Digital Architecture by the Director's Special Ops Dev.
 */
contract RepresentationProtocol {
    address public immutable DIRECTOR; // Ikaw ito, Captain Vin
    address public legalCounsel;
    
    enum CaseStatus { Inactive, Ongoing, Won, Lost, Settled }
    
    struct LegalMatter {
        string caseTitle;
        uint256 retainerFee;
        uint256 successFee;
        CaseStatus status;
        bool isEscrowed;
    }

    mapping(bytes32 => LegalMatter) public registry;
    
    event CounselEngaged(address indexed counsel);
    event MilestoneReleased(bytes32 indexed matterId, uint256 amount);
    event RepresentationTerminated(address indexed exCounsel);

    modifier onlyDirector() {
        require(msg.sender == DIRECTOR, "UNAUTHORIZED: Only the Director can command this protocol.");
        _;
    }

    constructor() {
        DIRECTOR = msg.sender;
    }

    /**
     * @dev I-assign ang napiling Abogado o Law Firm.
     */
    function engageCounsel(address _counsel) external onlyDirector {
        legalCounsel = _counsel;
        emit CounselEngaged(_counsel);
    }

    /**
     * @dev Mag-setup ng bagong kaso o SEC compliance project.
     * @param _matterId Unique ID ng legal matter (e.g., keccak256("SEC_GIS_2026"))
     */
    function setupMatter(
        bytes32 _matterId, 
        string memory _title, 
        uint256 _retainer, 
        uint256 _success
    ) external payable onlyDirector {
        require(msg.value >= _retainer, "INSUFFICIENT_FUNDS: Retainer must be pre-funded.");
        
        registry[_matterId] = LegalMatter({
            caseTitle: _title,
            retainerFee: _retainer,
            successFee: _success,
            status: CaseStatus.Ongoing,
            isEscrowed: true
        });
    }

    /**
     * @dev Release ng Success Fee kapag tapos na ang trabaho (e.g., SEC Approval).
     */
    function triggerSuccessPayout(bytes32 _matterId) external onlyDirector {
        LegalMatter storage matter = registry[_matterId];
        require(matter.status == CaseStatus.Ongoing, "ERROR: Matter already closed.");
        
        matter.status = CaseStatus.Won;
        payable(legalCounsel).transfer(matter.successFee);
        
        emit MilestoneReleased(_matterId, matter.successFee);
    }

    /**
     * @dev "Kill Switch" - Kung hindi nag-deliver ang abogado, bawiin ang control at pondo.
     */
    function terminateRepresentation() external onlyDirector {
        address exCounsel = legalCounsel;
        legalCounsel = address(0);
        emit RepresentationTerminated(exCounsel);
    }

    // Function to receive funds for the Legal War Chest
    receive() external payable {}
}
