// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// import forge-std/Test.sol
import "forge-std/Test.sol";

// import VRFCoordinatorV2Mock contract from src/VRFCoordinatorV2Mock.sol
import {VRFCoordinatorV2Mock} from "src/mocks/VRFCoordinatorV2Mock.sol";

// test contract, where we will test VRFCoordinatorV2Mock contract
contract VRFCoordinatorV2MockTest is Test {
    // creating a new instance of VRFCoordinatorV2Mock contract
    VRFCoordinatorV2Mock public vrfCoordinatorV2Mock;
    uint96 public constant BASE_FEE = 250000000000000000; //0.25 is this the premium in LINK?
    uint96 public constant GAS_PRICE_LINK = 1e9;

    // this function will deploy VRFCoordinatorV2Mock contract
    function setUp() public {
        // creating a new instance of VRFCoordinatorV2Mock contract
        vrfCoordinatorV2Mock = new VRFCoordinatorV2Mock(BASE_FEE, GAS_PRICE_LINK);
        // we passed it as a parameter to constructor of VRFCoordinatorV2Mock contract
    }

    function testVRFCoordinatorV2Mock() public {}
}
