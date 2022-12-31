// SPDX-License-Identifier: UNLICENSED
// making solidity script which will implement the Raffle contract
// Compare this snippet from src/Raffle.sol:
pragma solidity ^0.8.17;

// forge script import to use the Script contract
import "forge-std/Script.sol";
// import Raffle contract from src/Raffle.sol
import {Raffle} from "src/Raffle.sol";
// import HelperConfig contract from script folder
import {HelperConfig} from "script/HelperConfig.sol";
// importing mock --> we need to use mock on anvil network
import {VRFCoordinatorV2Mock} from "src/test/VRFCoordinatorV2Mock.sol";

// this contract will deploy Raffle contract
// contract can use function from Script and HelperConfig contracts
contract DeployRaffle is Script, HelperConfig {
    // state variable _baseFee (mock argument)
    uint96 private constant _baseFee = 250000000000000000; //0.25 is this the premium in LINK?
    // state variable _gasPriceLink (mock argument)
    uint96 private constant _gasPriceLink = 1e9;

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
            uint256 interval // calling activeNetworkConfig function from HelperConfig contract // returns which network we are on and config for that network
        ) = helperConfig.activeNetworkConfig();

        // if we are on anvil network we need to deploy VRFCoordinatorV2Mock contract
        if (vrfCoordinator == address(vrfCoordinatorV2MockAddress)) {
            // we nee to put mock arguments: (_baseFee, _gasPriceLink)
            vrfCoordinator = address(new VRFCoordinatorV2Mock(_baseFee, _gasPriceLink));
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

        vm.stopBroadcast();
    }
}
