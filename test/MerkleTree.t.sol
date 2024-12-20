// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MerkleTree.sol";

contract MerkleTreeTest is Test {
    MerkleTree merkleTree;

    function setUp() public {
        merkleTree = new MerkleTree();
    }

    function testMakeTree() public {
        bytes32[] memory leaves = new bytes32[](4);
        leaves[0] = keccak256(abi.encodePacked("leaf1"));
        leaves[1] = keccak256(abi.encodePacked("leaf2"));
        leaves[2] = keccak256(abi.encodePacked("leaf3"));
        leaves[3] = keccak256(abi.encodePacked("leaf4"));

        merkleTree.make_tree(leaves);

        bytes32 expectedRoot = keccak256(abi.encodePacked(
            keccak256(abi.encodePacked(leaves[0], leaves[1])),
            keccak256(abi.encodePacked(leaves[2], leaves[3]))
        ));

        assertEq(merkleTree.get_root(), expectedRoot);
    }

    function testEmptyLeaves() public {
        bytes32[] memory emptyLeaves = new bytes32[](0);
        
        vm.expectRevert("Leaves cannot be empty");
        merkleTree.make_tree(emptyLeaves);
    }

    function testSingleLeaf() public {
        bytes32[] memory singleLeaf = new bytes32[](1);
        singleLeaf[0] = keccak256(abi.encodePacked("singleLeaf"));

        merkleTree.make_tree(singleLeaf);

        assertEq(merkleTree.get_root(), singleLeaf[0]);
    }
}
