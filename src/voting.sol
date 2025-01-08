// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Voting contract
/// @author Meet Jain
/// @dev add candidates to vote, gives access to the admin and checks if the voter has already voted or not

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address public owner;
    mapping(address => bool) public voters;

    event VoteCast(address indexed voter, uint256 indexed candidateIndex);
    event CandidateAdded(string name);

    constructor(string[] memory _candidateNames) {
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            candidates.push(Candidate({
                name: _candidateNames[i],
                voteCount: 0
            }));
        }
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
     
    // this function add the candidate who are eligible to vote
    function addCandidate(string memory _name) public onlyOwner { 
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
        emit CandidateAdded(_name);
    }

    // checks if voter has already voted or not
    function castVote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate index");

        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
        emit VoteCast(msg.sender, _candidateIndex);
    }

    // getter function which returns all the candidates
    function getAllCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}
