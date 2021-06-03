// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleBank {

    mapping(address => uint256) private balances;
    mapping(address => bool) public enrolled;
    address public owner;

    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint256 amount);
    event LogWithdrawal(address accountAddress, uint256 withdrawAmount, uint256 newBalance);

    constructor() {
        owner = msg.sender;
    }

    fallback() external payable {
        revert();
    }

    receive() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool) {
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return true;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint256) {
        require(enrolled[msg.sender], 'Not enrolled');

        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return msg.value;
    }

    /// @notice Withdraw ether from bank
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint256 withdrawAmount) public returns (uint256) {
        require(enrolled[msg.sender], "Not enrolled");
        require(balances[msg.sender] >= withdrawAmount, "Insufficient funds");

        balances[msg.sender] -= withdrawAmount;
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        payable(msg.sender).transfer(withdrawAmount);
        return withdrawAmount;
    }
}
