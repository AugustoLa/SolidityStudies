// Get funds from users
// Withdraw funds
// et a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant miniumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public adressToAmountFunded;

    address public immutable i_owner;

    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= miniumUsd,
            "Didn't send enough"
        );
        funders.push(msg.sender);
        adressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyi_owner {
        /* starting index, ending index, step amount*/
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex = funderIndex++
        ) {
            address funder = funders[funderIndex];
            adressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        /*transfer
         payable(msg.sender).transfer(address(this).balance);
         //send
         bool sendSucess = payable(msg.sender).send(address(this).balance);
         require(sendSucess, "Send failed"); */
        // call
        (bool callSucess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucess, "Call failed");
    }

    modifier onlyi_owner() {
        //     require(msg.sender == i_owner, NotOwner());

        if (msg.sender != i_owner) {
            revert NotOwner();
        }

        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
