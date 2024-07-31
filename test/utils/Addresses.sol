// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Vm} from "forge-std/Vm.sol";
import {LibString} from "lib/solady/src/utils/LibString.sol";

library Addresses {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function resolve(string calldata name) public view returns (address) {
        string memory chain;
        if (block.chainid == 1) {
            chain = "Mainnet";
        } else if (block.chainid == 17000) {
            chain = "Holeski";
        } else {
            revert("Addresses: unsupported chain");
        }
        return getAddress(chain, name);
    }

    function getAddress(string memory chain, string calldata name) public view returns (address) {
        // Read library file
        string memory file = vm.readFile(string(abi.encodePacked(vm.projectRoot(), "/test/utils/", chain, ".sol")));

        // Address index starts after the name index + name length + 3 (for `space` + `=` + `space`)
        uint256 index = getIndex(file, name) + LibString.runeCount(name) + 3;

        // Get address
        return vm.parseAddress(LibString.slice(file, index, index + 42));
    }

    function getIndex(string memory file, string memory name) public pure returns (uint256) {
        uint256[] memory indexes = LibString.indicesOf(file, name);
        if (indexes.length == 0) {
            revert("Addresses: name not found");
        } else if (indexes.length == 1) {
            // Only one name found, simple case
            return indexes[0];
        } else {
            // Multiple names found, need to pick only the correct one
            // So we check that the next string after the name is ` = 0x`
            string[] memory splitted = LibString.split(file, name);

            for (uint256 i = 0; i < splitted.length; i++) {
                if (LibString.eq(LibString.slice(splitted[i + 1], 0, 5), " = 0x")) {
                    return indexes[i];
                }
            }
        }
        return type(uint256).max;
    }
}
