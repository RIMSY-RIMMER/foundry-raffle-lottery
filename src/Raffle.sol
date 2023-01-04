// Raffle contract
// Enter the raffle by sending some ether
// Pick a winner randomly (verifiably random)
// Winner to be selected every X minute --> completly automated
// Chainlink Oracle --> Randomness
// Chainlink Keepers --> Autfotomated execution

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

error Raffle__NotEnoughEtherSent();
error Raffle__TransferFailed();
error Raffle__RaffleNotOpen();
error Raffle__UpkeepNotNeeded(
    uint256 currenetBalance,
    uint256 numPlayers,
    uint256 raffleState
);

/* -------------- Imports --------------*/
// import Chainlink contract VRFv2
import "chainlink/VRFConsumerBaseV2.sol";
// import interface of contract: CoordinatorV2
import "chainlink/interfaces/VRFCoordinatorV2Interface.sol";
// import interface of Chainlink Keepers contract
import "chainlink/interfaces/AutomationCompatibleInterface.sol";

/* -------------- Contract --------------*/
/** @title Raffle contract
 * @author rimsy_rimmer
 * @notice this contract creates decentralized lottery
 * @dev this implements Chainlink VRF and Chainlink Keepers
 *
 */
// we need to inherit from VRFConsumerBaseV2 `contract Raffle is VRFConsumerBaseV2`
contract Raffle is VRFConsumerBaseV2, AutomationCompatibleInterface {
    /* -------------- Type Declaration  --------------*/
    // enum type declaration --> state of the contract
    // means: uint256 where 0 = OPEN and 1 = CALCULATING
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    /* --------------State Variables (storage / non-storage) -------------- */
    // Settting minimum amount of ether to enter the raffle
    // s_ --> storage variable
    // i_ --> immutable variable
    // setting s_entranceFee only one time --> immutable/ constant (gas saving)
    uint256 private immutable i_entranceFee;
    // array of players s_ (storage)
    // address need to be payable because it it wins we will send ETH to it
    address payable[] private s_players;
    // address of the Chainlink VRF Coordinator
    // setting it in contructor only 1 time --> private immutable
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    // gasLane state variable --> immutable (sets only once)
    bytes32 private immutable i_gasLane;
    // subscriptionId state variable --> immutable (sets only once)
    uint64 private immutable i_subscriptionId;
    // callbackGasLimit state variable --> immutable (sets only once)
    uint32 private immutable i_callbackGasLimit;
    // requestConfirmations constant = 3, CAPSLOCK for constants
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    // number of random words we want to receive
    uint16 private constant NUM_WORDS = 1;

    /* -------------- Lottery Variables  --------------*/
    // recentWinner state variable
    address payable public s_recentWinner;
    // definning a different state of the contract (pending, open, closed etc.)
    uint256 private s_state;
    // raffle state variable
    RaffleState private s_raffleState;
    // state variable which will keep previous block timestamp
    uint256 private s_lastTimeStamp;
    // state variable which will keep the time interval
    uint256 private immutable i_interval;

    /* -------------- Events --------------*/
    event RaffleEnter(address indexed player);
    event RequestedRaffleWinner(uint256 indexed requestId);
    event WinnerPicked(address indexed winner);

    /* -------------- Functions --------------*/
    // Want be able to set the entrance fee
    // Address of the Chainlink VRF Coordinator --> random number verification
    constructor(
        address vrfCoordinatorV2,
        uint256 entranceFee,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        uint256 interval
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        i_interval = interval;
    }

    function enterRaffle() public payable {
        // Check if the user has sent enough ether
        // Gas Ef. `error code` --> not string "Not enough ether sent"
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEtherSent();
        }
        // enter raffle only if the raffle is open
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }

        // add the user to the players array
        // msg.sender is not payable --> need to cast it
        s_players.push(payable(msg.sender));

        // Emit an event when we update a dynamic array or mapping
        // Named events with the function name reversed
        emit RaffleEnter(msg.sender);
    }

    /** 
    @dev function checkUpkeep, parameters --> same as in interface
    * this is the function that Chainlink Keepers Nodes call
    * they look for the `upKeyNeeded` to return true 
    * the following should be true in order to return true:
    * 1. our time interval should have passed
    * 2. the lottery should have at least 1 player and some ETH
    * 3. our subscription is funded with LINK
    * 4. the lottery should be in an `open` state
    *   --> when we are waiting to random number to be returned
    *   --> should not allowed players to join 
    */
    function checkUpkeep(
        bytes memory /* checkData */
    ) public view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool isOpen = (RaffleState.OPEN == s_raffleState);
        // time interval should have passed --> block.timestamp
        bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
        // check if we have at least 1 player and some ETH
        bool hasPlayers = (s_players.length > 0);
        // has a balance
        bool hasBalance = address(this).balance > 0;
        // takink all the boolen variables and check if they are true
        upkeepNeeded = (isOpen && timePassed && hasPlayers && hasBalance);
    }

    // request a random number
    // function will be called by Chainlink Keepers Network (automated)
    // function will be external (own contract cannot call it), it will save gas
    function performUpkeep(bytes calldata /* performData */) external override {
        // want to see upKeepNeeded to be true
        (bool upKeepNeeded, ) = checkUpkeep("");
        // if upKeepNeeded is false --> revert
        if (!upKeepNeeded) {
            // add some variables to the revert message --> revert with reason
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }
        s_raffleState = RaffleState.CALCULATING;
        // run the requestRandomWords function on address of the VRF Coordinator
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            // keyHash / gasLane --> maximumium amount of gas we are willing to pay
            // sets in constructor and save as an state variable
            i_gasLane,
            // subId that is used to request random number
            i_subscriptionId,
            // how many conf. chainlink should wait, set it as constant = 3
            REQUEST_CONFIRMATIONS,
            // limit how much gas we are willing to pay for the callback function
            i_callbackGasLimit,
            // how many random numbers we want to receive --> 1 --> constant
            NUM_WORDS
        );
        emit RequestedRaffleWinner(requestId);
    }

    // mmeans: fulfill random number
    function fulfillRandomWords(
        uint256 /* requestId */,
        uint256[] memory randomWords
    ) internal override {
        // get a random number which is the index of the winner
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        // get the address of the winner
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        // change of the raffle to open again
        s_raffleState = RaffleState.OPEN;
        // reset the players array
        s_players = new address payable[](0);
        // reset the time stamp
        s_lastTimeStamp = block.timestamp;
        // send the winner the entire balance of the contract
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // require that the transfer was successful
        if (!success) {
            revert Raffle__TransferFailed();
        }
        // emit an event
        emit WinnerPicked(recentWinner);
    }

    /* -------------- View / Pure getter functions -------------- */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    // We want to see who is in the players array
    function getPlayers(uint256 index) public view returns (address) {
        return s_players[index];
    }

    // we want to see recent winner
    function getRecentWinner() public view returns (address) {
        return s_recentWinner;
    }

    // we want to see the raffle state
    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }

    // we want to see number of words
    function getNumWords() public pure returns (uint256) {
        return NUM_WORDS;
    }

    // want to see number of players
    function getNumPlayers() public view returns (uint256) {
        return s_players.length;
    }

    // want to see the last time stamp
    function getLastTimeStamp() public view returns (uint256) {
        return s_lastTimeStamp;
    }

    // want to see request confirmations
    function getRequestConfirmations() public pure returns (uint256) {
        return REQUEST_CONFIRMATIONS;
    }

    // want to see the interval
    function getInterval() public view returns (uint256) {
        return i_interval;
    }
}
