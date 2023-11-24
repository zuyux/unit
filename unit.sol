// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UNIt {
    string public name = "UNIt";
    string public symbol = "UNIT";
    uint256 public totalTokens = 1000000000000;

    mapping(address => uint256) public balances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address to, uint256 value) public {
        require(balances[msg.sender] >= value, "Insufficient balance.");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function balanceOf(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function mint(address to, uint256 value) public {
        require(msg.sender == address(this), "Only the contract owner can mint tokens.");
        totalTokens += value;
        balances[to] += value;
        emit Transfer(address(0), to, value);
    }
}

