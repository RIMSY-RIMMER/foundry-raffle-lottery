// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import mock contract from chainlink library
// import {VRFCoordinatorV2Mock} from "src/mocks/VRFCoordinatorV2Mock.sol";

// HelperConfig contract which will help to set behavior of the Raffle contract on ddifferent networks
contract HelperConfig {
    // VRFCoordinatorV2Mock vrfCoordinatorV2Mock;
    // address vrfCoordinatorV2MockAddress = address(vrfCoordinatorV2Mock);

    // state variable which will store the NetworkConfig for the active network
    // whith all the parameters from the Raffle contract constructor
    NetworkConfig public activeNetworkConfig;

    // parameters in struct is the same as in Raffle contract constructor
    struct NetworkConfig {
        address vrfCoordinator;
        uint256 entranceFee;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
        uint256 interval;
    }

    // mapping which will store the NetworkConfig for each network
    mapping(uint256 => NetworkConfig) public chainIdNetworkConfig;

    // constructor which will set the activeNetworkConfig by the chainId
    // it initializes `activeNetworkConfig` variable based on the `chainIdNetworkConfig` mapping
    constructor() {
        chainIdNetworkConfig[5] = getGoerliEthConfig();
        chainIdNetworkConfig[31337] = getAnvilEthConfig();
        // chainIdNetworkConfig[1337] = getGanacheEthConfig();
        // sets `activeNetworkConfig` variables to `NetworkConfig` struct
        // in the `chainIdNetworkConfig` mapping for the current chainId
        // `block.chainid` --> global object in Solidity
        // it is read-only property which returns chain ID of the current block as a uint256
        activeNetworkConfig = chainIdNetworkConfig[block.chainid];
    }

    // function which will return the NetworkConfig for the goerli network
    function getGoerliEthConfig()
        internal
        pure
        returns (
            // dousn't mofify any storage variables
            NetworkConfig memory goerliNetworkConfig
        )
    {
        // we need to put in data from constructor
        goerliNetworkConfig = NetworkConfig({
            vrfCoordinator: address(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D),
            entranceFee: 25e15, // 0.25 ETH
            gasLane: 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15,
            subscriptionId: 0,
            callbackGasLimit: 500000, // 500.000 Gas
            interval: 30
        });
    }

    // function which will return the NetworkConfig for the anvil network
    function getAnvilEthConfig()
        internal
        pure
        returns (NetworkConfig memory anvilNetworkConfig)
    {
        anvilNetworkConfig = NetworkConfig({
            //     vrfCoordinator = new MockVRFCoordinatorV2();
            vrfCoordinator: address(0), // mock
            entranceFee: 25e15, //2500000000000000000, // 0.25 ETH
            gasLane: 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15,
            //     subscriptionId = vrfCoordinator.createSubscription();
            subscriptionId: 0,
            callbackGasLimit: 500000, // 500.000 Gas
            interval: 30
        });
    }

    /*     function getGanacheEthConfig()
        internal
        view
        returns (NetworkConfig memory ganacheNetworkConfig)
    {
        ganacheNetworkConfig = NetworkConfig({
            vrfCoordinator: address(vrfCoordinatorV2MockAddress), // mock
            entranceFee: 25e15, //2500000000000000000, // 0.25 ETH
            gasLane: 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15,
            subscriptionId: 0,
            callbackGasLimit: 500000, // 500.000 Gas
            interval: 30
        });
    } */

    /* -------------- View / Pure getter functions -------------- */
    function getActiveNetworkConfig() external view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }

    function getGoerliNetworkConfig() external pure returns (NetworkConfig memory) {
        return getGoerliEthConfig();
    }

    /*     function getAnvilNetworkConfig() external view returns (NetworkConfig memory) {
        return getAnvilEthConfig();
    } */

    /*     function getGanacheNetworkConfig() external view returns (NetworkConfig memory) {
        return getGanacheEthConfig();
    } */

    function getNetworkConfig(uint256 chainId) external view returns (NetworkConfig memory) {
        return chainIdNetworkConfig[chainId];
    }

    function getVrfCoordinator() external view returns (address) {
        return activeNetworkConfig.vrfCoordinator;
    }

    function getEntranceFee() external view returns (uint256) {
        return activeNetworkConfig.entranceFee;
    }

    function getGasLane() external view returns (bytes32) {
        return activeNetworkConfig.gasLane;
    }

    function getSubscriptionId() external view returns (uint64) {
        return activeNetworkConfig.subscriptionId;
    }

    function getCallbackGasLimit() external view returns (uint32) {
        return activeNetworkConfig.callbackGasLimit;
    }

    function getInterval() external view returns (uint256) {
        return activeNetworkConfig.interval;
    }

    function getChainId() external view returns (uint256) {
        return block.chainid;
    }
}
