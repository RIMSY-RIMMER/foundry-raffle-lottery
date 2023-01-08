// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.sol";
import {MockVRFCoordinatorV2} from "src/mocks/VRFCoordinatorV2Mock.sol";

// test contract, where we will test Raffle contract
contract RaffleTest is Test, HelperConfig {
    HelperConfig helperConfig;
    Raffle raffle;
    MockVRFCoordinatorV2 vrfCoordinator;

    address alice = address(0x1337);
    address bob = address(0x133702);

    // address vrfCoordinator = new VRFCoordinatorV2Mock()
    uint256 entranceFee = 25e15;
    bytes32 gasLane = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    // = vrfCoordinator.createSubscription();
    uint64 subscriptionId = 0;
    uint32 callbackGasLimit = 500000;
    uint256 interval = 30;

    // function setUp will run before each test case
    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        helperConfig = new HelperConfig();
        vrfCoordinator = new MockVRFCoordinatorV2();
        raffle = new Raffle(
            address(vrfCoordinator),
            entranceFee,
            gasLane,
            subscriptionId,
            callbackGasLimit,
            interval
        );
    }

    /* -------------- Constructor Test --------------*/
    /*  test of constructor function
        1. Raffle state test --> initialize the Raffle correctly
        2. getting the Raffle State 
        3. assertTrue
        test if internval is set correctly
        1. getting interval --> getter function
        2. assert (interval should equal to interval in setUp function)
     */
    // function testConstructor() public {}

    /* -------------- Functions Tests --------------*/
    // it reverts when you try to enter the raffle with an amount less than the entrance fee
    function testRevertsWhenNotEnoughEth() public {
        uint256 i_entranceFee = raffle.getEntranceFee();
        // Expects an error on next call
        vm.expectRevert(Raffle.Raffle__NotEnoughEtherSent.selector);
        raffle.enterRaffle{value: i_entranceFee - 1}();
    }

    // test that array will records player when they enter the raffle
    function testRecordsPlayerWhenTheyEnterRaffle() public {
        // entrance fee is 0.1 ETH or bigger than that
        uint256 i_entranceFee = raffle.getEntranceFee();
        // enter the raffle with a value of the entrance fee
        raffle.enterRaffle{value: i_entranceFee}();
        // assert that that function getNumPlayers returns 1
        assertTrue(raffle.getNumPlayers() == 1);
    }

    /*     // test if it reverts when you try to enter the raffle when the raffle is calculating
    function testRevertsWhenRaffleIsCalculating() public {
        // Expects an error on next call
        vm.expectRevert();
        // we need to get raffle to calculating state
        // we need to make sure that up keep returns true
        raffle.enterRaffle{value: 1}();
    } */

    /* -------------- Emit Event --------------*/
    // test if emit event is called when player enters the raffle
    // emits RaffleEnter event if entered to index player(s) address
    // we need to declare event locally
    /*     event RaffleEnter(address indexed player);

    function testEmitsEventWhenPlayerEntersRaffle() public {
        vm.expectEmit(true, false, false, true);
        emit RaffleEnter();
        raffle.enterRaffle{value: entranceFee}();
    } */

    /*  make sure that it does not allowed entrance, when the Raffle is Calculating
        need to get Raffle to closed state
        need to make  to check up keep returns true
        faundry cheats - becouse now each interval is 30 seconds
     */
    //function testDoesNotAllowEntranceWhenRaffleIsCalculating() public {}
}
