// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import forge-std/Test.sol
import "forge-std/Test.sol";
// import Raffle contract from src/Raffle.sol
import {Raffle} from "src/Raffle.sol";

// test contract, where we will test Raffle contract
contract RaffleTest is Test {
    Raffle raffle;
    address vrfCoordinator;
    uint256 entranceFee;
    bytes32 gasLane;
    uint64 subscriptionId;
    uint32 callbackGasLimit;
    uint256 interval;

    // function setUp will run before each test case
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

    /*  test of constructor function
        1. Raffle state test --> initialize the Raffle correctly
        2. getting the Raffle State 
        3. assertTrue
        test if internval is set correctly
        1. getting interval --> getter function
        2. assert (interval should equal to interval in setUp function)
     */
    function testConstructor() public {}

    /*  test of enterRaffle function
        it reverts when you try to enter the raffle with an amount less than the entrance fee
     */
    function testEnterRaffleRevertsWhenAmountLessThanEntranceFee() public {}

    /*  records player when they enter the raffle
        we need raffle entrance fee which we use to enter the raffle
        entter raffel with a value of the entrance fee
      */
    function testRecordsPlayerWhenTheyEnterRaffle() public {}

    /* test if emit event is called when player enters the raffle
        we need to emit event when player enters the raffle
        we need to call enterRaffle function
        we need to check if event is emitted
     */
    function testEmitsEventWhenPlayerEntersRaffle() public {}

    /*  make sure that it does not allowed entrance, when the Raffle is Calculating
        need to get Raffle to closed state
        need to make  to check up keep returns true
        faundry cheats - becouse now each interval is 30 seconds
     */
    function testDoesNotAllowEntranceWhenRaffleIsCalculating() public {}
}
