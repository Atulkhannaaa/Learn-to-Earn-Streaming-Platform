// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MentalHealthChallenge {
    struct Challenge {
        string title;
        string description;
        uint256 rewardAmount;
        address creator;
        bool isCompleted;
    }

    mapping(uint256 => Challenge) public challenges;
    mapping(address => uint256) public balances;
    uint256 public challengeCounter;

    event ChallengeCreated(uint256 challengeId, string title, address creator);
    event ChallengeCompleted(uint256 challengeId, address completer);
    event RewardWithdrawn(address user, uint256 amount);

    function createChallenge(string memory title, string memory description, uint256 rewardAmount) public payable {
        require(msg.value == rewardAmount, "Reward amount must be sent with the challenge creation.");

        challenges[challengeCounter] = Challenge({
            title: title,
            description: description,
            rewardAmount: rewardAmount,
            creator: msg.sender,
            isCompleted: false
        });

        emit ChallengeCreated(challengeCounter, title, msg.sender);
        challengeCounter++;
    }

    function completeChallenge(uint256 challengeId) public {
        Challenge storage challenge = challenges[challengeId];
        require(!challenge.isCompleted, "Challenge is already completed.");

        challenge.isCompleted = true;
        balances[msg.sender] += challenge.rewardAmount;

        emit ChallengeCompleted(challengeId, msg.sender);
    }

    function withdrawRewards() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No rewards to withdraw.");

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit RewardWithdrawn(msg.sender, amount);
    }

    function getChallenge(uint256 challengeId) public view returns (string memory, string memory, uint256, address, bool) {
        Challenge memory challenge = challenges[challengeId];
        return (
            challenge.title,
            challenge.description,
            challenge.rewardAmount,
            challenge.creator,
            challenge.isCompleted
        );
    }
}
