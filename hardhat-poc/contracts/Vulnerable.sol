// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vulnerable {
    mapping(address => uint256) public balances;

    function donate() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Nothing to withdraw");
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "Failed");
        balances[msg.sender] = 0;
    }

    receive() external payable {}
}
