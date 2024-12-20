// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MerkleTree} from "../src/MerkleTree.sol";
import {TransactionGenerator} from "../src/TransactionGenerator.sol";

contract MerkleTreeTask is Script {
    MerkleTree merkleTree;
    bytes32 public merkleRoot;
    bool isSolved;

    function setUp() public {}
    
    function generateTest(string memory test_seed) external returns (string[] memory) {
        isSolved = false;
        TransactionGenerator generator = new TransactionGenerator();

        string[] memory transactions = generator.generate(test_seed);
        uint256 length = transactions.length;
        bytes32[] memory leaves = new bytes32[](length);
        for (uint i = 0; i < length; ++i) {
            leaves[i] = keccak256(abi.encodePacked(transactions[i]));
        }
        
        MerkleTree mTree = new MerkleTree();
        
        mTree.make_tree(leaves);
        merkleRoot = mTree.get_root();
        return transactions;
    }

    function submit(bytes32 answer) public {
        if (answer == merkleRoot)
        {
            isSolved = true;
        }
    }

    function solved() public view returns (bool){
        return isSolved;
    }
}

contract Solution is Script {
    
    function setUp() public {

    }

    function getMerkleRoot(bytes32[] memory leaves) internal pure returns (bytes32) {
        uint256 n = leaves.length;

        if (n == 1) {
            return leaves[0];
        }

        bytes32[] memory currentLevel = leaves;

        while (currentLevel.length > 1) {
            uint256 nextLevelSize = (currentLevel.length + 1) / 2;
            bytes32[] memory nextLevel = new bytes32[](nextLevelSize);

            for (uint256 i = 0; i < currentLevel.length / 2; i++) {
                nextLevel[i] = keccak256(abi.encodePacked(currentLevel[i * 2], currentLevel[i * 2 + 1]));
            }

            if (currentLevel.length % 2 == 1) {
                nextLevel[nextLevelSize - 1] = currentLevel[currentLevel.length - 1];
            }

            currentLevel = nextLevel;
        }

        return currentLevel[0];
    }

    function run() public {
        MerkleTreeTask task = new MerkleTreeTask();
        string memory test_seed = "123456789012345";
        string[] memory transactions = task.generateTest(test_seed);

        for (uint i = 0; i < transactions.length; ++i) {
            console.log(transactions[i]);
        }

        uint256 length = transactions.length;
        bytes32[] memory leaves = new bytes32[](length);
        for (uint i = 0; i < length; ++i) {
            leaves[i] = keccak256(abi.encodePacked(transactions[i]));
        }

        bytes32 root = getMerkleRoot(leaves);
        task.submit(root);
        console.log("Task is solved: ", task.solved());
        require(task.solved());
    }

}
