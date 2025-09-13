// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.28;

//import "hardhat/consol.sol";

contract MyToken {

    //  State Variables 

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public cap;
    bool private paused;
    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    mapping(address => bool) private frozenAccounts;

    // Modifiers 

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "not paused");
        _;
    }

    modifier notFrozen(address account) {
        require(!frozenAccounts[account], "account is frozen");
        _;
    }

    //  Events 

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address account);
    event Unpaused(address account);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    //  Constructor 

    constructor() {
        name = "Shitzu";
        symbol = "shit";
        decimals = 18;
        cap = 20000000 * 10 ** decimals;
        totalSupply = cap;
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
        owner = msg.sender;
    }

    // Public View Functions 

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function allowance(address owner_, address spender) public view returns (uint256) {
        return allowances[owner_][spender];
    }

    function isFrozen(address account) public view returns (bool) {
        return frozenAccounts[account];
    }

    function _owner() public view returns (address) {
        return owner;
    }

    //  Internal Functions 

    function _transfer(address from, address to, uint256 amount) internal whenNotPaused notFrozen(from) notFrozen(to) {
        require(to != address(0), "invalid address");
        require(balances[from] >= amount, "insufficient balance");

        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner_, address spender, uint256 amount) internal {
        require(owner_ != address(0), "invalid address");
        require(spender != address(0), "invalid address");
        allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
    }

    function _spendAllowance(address owner_, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowances[owner_][spender];
        require(currentAllowance >= amount, "insufficient allowance");
        _approve(owner_, spender, currentAllowance - amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "invalid address");
        require(totalSupply + amount <= cap, "cap exceeded");
        totalSupply += amount;
        balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "invalid address");
        require(balances[from] >= amount, "insufficient balance");
        balances[from] -= amount;
        totalSupply -= amount;
        emit Transfer(from, address(0), amount);
    }

    //  Public Write Functions 

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        _transfer(from, to, amount);
        _spendAllowance(from, msg.sender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0), "invalid address");
        uint256 newAllowance = allowances[msg.sender][spender] + addedValue;
        _approve(msg.sender, spender, newAllowance);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0), "invalid address");
        uint256 currentAllowance = allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "decreased allowance below zero");
        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }

    function burnFrom(address account, uint256 amount) public returns (bool) {
        _spendAllowance(account, msg.sender, amount);
        _burn(account, amount);
        return true;
    }

    //  Ownership Functions

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    //  Pausable Functions 

    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpaused(msg.sender);
    }

    //  Freeze Functions 
    
    function freeze(address account) public onlyOwner {
        frozenAccounts[account] = true;
    }

    function unfreeze(address account) public onlyOwner {
        frozenAccounts[account] = false;
    }
}