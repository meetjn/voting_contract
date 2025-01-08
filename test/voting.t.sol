import {Test, console} from "forge-std/Test.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {Voting} from "../src/voting.sol";

contract VotingTest is Test {
    Voting public votingContract;
    address public owner;
    address public voter1;
    address public voter2;

    function setUp() public {
        owner = address(this);
        voter1 = address(0x1);
        voter2 = address(0x2);

        string[] memory initialCandidates = new string[](2);
        initialCandidates[0] = "Candidate 1";
        initialCandidates[1] = "Candidate 2";

        votingContract = new Voting(initialCandidates);
    }

    function testInitialCandidates() public {
        Voting.Candidate[] memory candidates = votingContract.getAllCandidates();
        assertEq(candidates.length, 2);
        assertEq(candidates[0].name, "Candidate 1");
        assertEq(candidates[0].voteCount, 0);
        assertEq(candidates[1].name, "Candidate 2");
        assertEq(candidates[1].voteCount, 0);
    }

    function testAddCandidate() public {
        votingContract.addCandidate("Candidate 3");
        Voting.Candidate[] memory candidates = votingContract.getAllCandidates();
        assertEq(candidates.length, 3);
        assertEq(candidates[2].name, "Candidate 3");
        assertEq(candidates[2].voteCount, 0);
    }

    function testCastVote() public {
        vm.prank(voter1);
        votingContract.castVote(0);

        Voting.Candidate[] memory candidates = votingContract.getAllCandidates();
        assertEq(candidates[0].voteCount, 1);
        assertTrue(votingContract.voters(voter1));
    }

    function testCannotVoteTwice() public {
        vm.prank(voter1);
        votingContract.castVote(0);

        vm.expectRevert("You have already voted");
        vm.prank(voter1);
        votingContract.castVote(1);
    }

    function testCannotVoteForInvalidCandidate() public {
        vm.expectRevert("Invalid candidate index");
        vm.prank(voter1);
        votingContract.castVote(99);
    }

    function testOnlyOwnerCanAddCandidate() public {
        vm.expectRevert("Only the owner can call this function");
        vm.prank(voter1);
        votingContract.addCandidate("Candidate 3");
    }
}
