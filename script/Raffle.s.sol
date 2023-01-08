// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
// Test: becouse of emit log functions --> test
import "forge-std/Test.sol";
import {Raffle} from "src/Raffle.sol";
import {HelperConfig} from "script/HelperConfig.sol";
import {MockVRFCoordinatorV2} from "src/mocks/VRFCoordinatorV2Mock.sol";

// this contract will deploy Raffle contract
// contract can use function from Script and HelperConfig contracts
contract DeployRaffle is Script, HelperConfig, Test {
    // run function will be called when script is run
    function run() external {
        // creating a new instance of HelperConfig contract
        HelperConfig helperConfig = new HelperConfig();
        // activeNetworkConfig will return the NetworkConfig struct for the active network
        (
            address vrfCoordinator,
            uint256 entranceFee,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callbackGasLimit,
            uint256 interval
        ) = // calling activeNetworkConfig function from HelperConfig contract // returns which network we are on and config for that network
            helperConfig.activeNetworkConfig();

        // if we are on anvil network we need to deploy VRFCoordinatorV2Mock contract
        if (vrfCoordinator == address(0)) {
            vrfCoordinator = address(new MockVRFCoordinatorV2());
        }

        // if chain is 31337 (anvil) we need to create subscription
        /*         if (block.chainid == 31337) {
            // we need to call createSubscription function from VRFCoordinatorV2Mock contract
            // we need to pass in arguments: (gasLane, subscriptionId, callbackGasLimit, interval)
            VRFCoordinatorV2Mock(vrfCoordinator).createSubscription(
                gasLane,
                subscriptionId,
                callbackGasLimit,
                interval
            );
        }
 */
        vm.startBroadcast();
        // deploy Raffle contract
        new Raffle(
            vrfCoordinator,
            entranceFee,
            gasLane,
            subscriptionId,
            callbackGasLimit,
            interval
        );

        emit log_named_address("Mock Adress", vrfCoordinator);
        emit log_named_uint("Entrance Fee", entranceFee);
        emit log_named_bytes32("Gas Lane", gasLane);
        emit log_named_uint("Subscription Id", subscriptionId);
        emit log_named_uint("Callback Gas Limit", callbackGasLimit);
        emit log_named_uint("Interval", interval);

        /*         console.logAddress(address(vrfCoordinator));
        console.logUint(helperConfig.getEntranceFee());
        console.logBytes32(helperConfig.getGasLane());
        console.logUint(helperConfig.getSubscriptionId());
        console.logUint(helperConfig.getCallbackGasLimit());
        console.logUint(helperConfig.getInterval()); */

        vm.stopBroadcast();
    }
}
