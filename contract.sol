// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MagicTokenCTR {
    address public owner;
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;
    bool public paused;

    mapping(address => uint256) private balanceOf;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address _owner, uint256 _supply) {
        name = "MagicToken";
        symbol = "MAGE";
        decimals = 18;
        totalSupply = _supply;
        owner = _owner;
    }

    // Pause/Unpause Contract
    function setPause(bool _paused) public onlyOwner {
        paused = _paused;
    }

    function transfer(address _to, uint256 _value) public {
        // Check that receiving address is valid
        require(_to != address(0), "Recipient address is invalid.");

        // Check for valid balance and transaction amount
        require(
            balanceOf[msg.sender] >= _value && _value > 0,
            "Not enough balance."
        );

        // Check that contract is not paused
        require(paused != true, "The contract is paused.");

        // Check that that totalSupply does not go below 0 when transferring tokens
        require(balanceOf[_to] + _value <= totalSupply);

        // transact
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    // check balance
    function balance() public view returns (uint256) {
        return balanceOf[msg.sender];
    }

    // Burn Function
    function burn(uint256 _value) public onlyOwner {
        // Check for valid balance and transaction amount
        require(
            balanceOf[msg.sender] >= _value && _value > 0,
            "Not enough balance."
        );

        require(msg.sender == owner, "you do not own this contract");

        // Check that contract is not paused
        require(paused != true, "The contract is paused.");

        // Burn tokens from sender's account
        totalSupply -= _value;
        balanceOf[msg.sender] -= _value;

        emit Transfer(msg.sender, address(0), _value);
    }
}
