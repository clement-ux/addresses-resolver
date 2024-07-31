// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";

import {Addresses} from "test/utils/Addresses.sol";

contract CounterTest is Test {
    function setUp() public {
        vm.createSelectFork("http://localhost:8545");
    }

    function test() public {
        Addresses.resolve("USDC");
    }
}
