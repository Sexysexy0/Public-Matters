// LandDAO.sol
pragma solidity ^0.8.0;

contract LandDAO {
    struct Parcel {
        uint256 id;
        string location;   // e.g. "Agricultural Land"
        string detail;     // e.g. "Ban mining in fertile soil"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public parcelCount;
    mapping(uint256 => Parcel) public parcels;

    event ParcelCreated(uint256 id, string location, string detail);
    event ParcelVoted(uint256 id, string location, bool support);
    event ParcelRatified(uint256 id, string location);
    event LandDeclared(string message);

    function createParcel(string memory location, string memory detail) public {
        parcelCount++;
        parcels[parcelCount] = Parcel(parcelCount, location, detail, 0, 0, false);
        emit ParcelCreated(parcelCount, location, detail);
    }

    function voteParcel(uint256 id, bool support) public {
        if (support) {
            parcels[id].votesFor++;
        } else {
            parcels[id].votesAgainst++;
        }
        emit ParcelVoted(id, parcels[id].location, support);
    }

    function ratifyParcel(uint256 id) public {
        Parcel storage p = parcels[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit ParcelRatified(p.id, p.location);
    }

    function declareLand() public {
        emit LandDeclared("Land DAO: safeguard arcs encoded into communal consequence.");
    }
}
