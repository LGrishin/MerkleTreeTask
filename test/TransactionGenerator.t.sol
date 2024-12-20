// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/TransactionGenerator.sol";
import {console} from "../lib/forge-std/src/Script.sol";

contract TestGenerator {
    TransactionGenerator generator;

    constructor() {
        generator = new TransactionGenerator();
    }

    function testGenerate(string memory input) public view returns (bool) {
        string[] memory transactions = generator.generate(input);
        
        uint base = 17;
        uint mod = 40;
        uint expectedSize = base + (bytes(input).length % mod);

        if (transactions.length != expectedSize) {
            return false;
        }

        for (uint i = 0; i < expectedSize; i++) {
            string memory expectedTransaction = string(abi.encodePacked("Transaction ", uintToString(i)));
            console.log(string(abi.encodePacked("Transaction ", uintToString(i + 1))));
            if (keccak256(abi.encodePacked(transactions[i])) != keccak256(abi.encodePacked(expectedTransaction))) {
                return false;
            }
        }

        return true;
    }

    function uintToString(uint v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        uint j = v;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (v != 0) {
            bstr[--k] = bytes1(uint8(48 + v % 10));
            v /= 10;
        }
        return string(bstr);
    }
}
