// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.sol";
import {MockVRFCoordinatorV2} from "src/mocks/VRFCoordinatorV2Mock.sol";

// test contract, where we will test Raffle contract
contract RaffleTest is Test, HelperConfig {
    // mock address of the vrfCoordinator
    // VRFCoordinatorV2Mock public vrfCoordinator;
    // create raffle contract with chainIdNetworkConfig[31337]
    HelperConfig public helperConfig;
    Raffle public raffle;
    MockVRFCoordinatorV2 public vrfCoordinator;

    // setting vrfCoordinator variable to adress from Helper Config function getVrfCoordinator

    // address vrfCoordinator = new VRFCoordinatorV2Mock()
    uint256 entranceFee = 25e15;
    bytes32 gasLane = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    // = vrfCoordinator.createSubscription();
    uint64 subscriptionId = 0;
    uint32 callbackGasLimit = 500000;
    uint256 interval = 30;

    // function setUp will run before each test case
    function setUp() public {
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

        console.logAddress(address(vrfCoordinator));
        console.logUint(entranceFee);
        emit log_uint(entranceFee);
        emit log_bytes32(gasLane);
        emit log_uint(subscriptionId);
        emit log_uint(callbackGasLimit);
        emit log_uint(interval);
        /*      vrfCoordinator = helperConfig.getVrfCoordinator();
        entranceFee = helperConfig.getEntranceFee();
        gasLane = helperConfig.getGasLane();
        subscriptionId = helperConfig.getSubscriptionId();
        callbackGasLimit = helperConfig.getCallbackGasLimit();
        interval = helperConfig.getInterval(); */
    }

    /*  test of constructor function
        1. Raffle state test --> initialize the Raffle correctly
        2. getting the Raffle State 
        3. assertTrue
        test if internval is set correctly
        1. getting interval --> getter function
        2. assert (interval should equal to interval in setUp function)
     */
    // function testConstructor() public {}

    /*  test of enterRaffle function
        it reverts when you try to enter the raffle with an amount less than the entrance fee
     */
    function testRevertsWhenNotEnoughEth() public {
        // we will use foundry cheatcodes --> expectRevert
        // enter Raffle with a value less than the entrance fee
        // uint256 i_entranceFee = raffle.getEntranceFee();
        uint256 i_entranceFee = raffle.getEntranceFee();
        raffle.enterRaffle{value: i_entranceFee - 1}();
        vm.expectRevert("Raffle__NotEnoughEtherSent");
    }

    /*  records player when they enter the raffle
        we need raffle entrance fee which we use to enter the raffle
        entter raffel with a value of the entrance fee
      */
    function testRecordsPlayerWhenTheyEnterRaffle() public {
        // entrance fee is 0.1 ETH or bigger than that
        uint256 i_entranceFee = raffle.getEntranceFee();
        // enter the raffle with a value of the entrance fee
        raffle.enterRaffle{value: i_entranceFee}();
        // assert that that function getNumPlayers returns 1
        assertTrue(raffle.getNumPlayers() == 1);
        emit log_uint(i_entranceFee);
    }

    /* test if emit event is called when player enters the raffle
        we need to emit event when player enters the raffle
        we need to call enterRaffle function
        we need to check if event is emitted
     */
    // function testEmitsEventWhenPlayerEntersRaffle() public {}

    /*  make sure that it does not allowed entrance, when the Raffle is Calculating
        need to get Raffle to closed state
        need to make  to check up keep returns true
        faundry cheats - becouse now each interval is 30 seconds
     */
    //function testDoesNotAllowEntranceWhenRaffleIsCalculating() public {}
}
