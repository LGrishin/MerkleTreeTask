// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MerkleTree {
    bytes32 public merkleRoot;

    function make_tree(bytes32[] memory leaves) public {
        require(leaves.length > 0, "Leaves cannot be empty");
        merkleRoot = buildMerkleTree(leaves);
    }

    function buildMerkleTree(bytes32[] memory leaves) internal pure returns (bytes32) {
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
                // this is error!
                nextLevel[nextLevelSize - 1] = currentLevel[0];
            }

            currentLevel = nextLevel;
        }

        return currentLevel[0];
    }

    function get_root() public view returns (bytes32) {
        return merkleRoot;
    }
}
