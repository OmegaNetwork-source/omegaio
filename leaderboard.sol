// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * @title Leaderboard
 * @dev A simple leaderboard contract to store the highest score for each player.
 */
contract Leaderboard {
    
    struct ScoreEntry {
        address player;
        uint256 score;
    }

    mapping(address => uint256) public highScores;
    address[] public players;
    
    event ScoreSubmitted(address indexed player, uint256 score);

    /**
     * @dev Submits a new score for the message sender.
     * The score is only updated if it's higher than the player's current high score.
     * @param _score The score to submit.
     */
    function submitScore(uint256 _score) public {
        if (highScores[msg.sender] == 0 && _score > 0) {
            players.push(msg.sender);
        }

        if (_score > highScores[msg.sender]) {
            highScores[msg.sender] = _score;
            emit ScoreSubmitted(msg.sender, _score);
        }
    }

    /**
     * @dev Returns the total number of players on the leaderboard.
     */
    function getPlayerCount() public view returns (uint256) {
        return players.length;
    }

    /**
     * @dev Returns the full leaderboard.
     * For performance, on a real-world dApp, this should be paginated.
     */
    function getLeaderboard() public view returns (ScoreEntry[] memory) {
        uint256 playerCount = players.length;
        ScoreEntry[] memory leaderboard = new ScoreEntry[](playerCount);
        
        for (uint256 i = 0; i < playerCount; i++) {
            address player = players[i];
            leaderboard[i] = ScoreEntry(player, highScores[player]);
        }
        
        return leaderboard;
    }
} 
