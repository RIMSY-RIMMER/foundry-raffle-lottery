// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import forge-std/Test.sol
import "forge-std/Test.sol";
// import Raffle contract from src/Raffle.sol
import {Raffle} from "src/Raffle.sol";

// test contract, where we will test Raffle contract
contract RaffleTest is Test {
    // state variable raffle
    Raffle raffle;
    // state variable vrfCoordinator
    address vrfCoordinator;
    // state variable entranceFee
    uint256 entranceFee;
    // state variable gasLane
    bytes32 gasLane;
    // state variable subscriptionId
    uint64 subscriptionId;
    // state variable callbackGasLimit
    uint32 callbackGasLimit;
    // state variable interval
    uint256 interval;

    // function setUp will be called before each test
    function setUp() public {
        // creating a new instance of Raffle contract
        raffle = new Raffle(
            vrfCoordinator,
            entranceFee,
            gasLane,
            subscriptionId,
            callbackGasLimit,
            interval
        );
    }

    // test function to test the Raffle contract
    function testRaffle() public {}
}
