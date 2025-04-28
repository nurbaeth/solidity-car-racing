// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarRacingGame {
    struct Player {
        address addr;
        uint256 position;
    }

    Player[] public players;
    uint256 public finishLine;
    bool public raceStarted;
    bool public raceFinished;
    address public winner;

    constructor(uint256 _finishLine) {
        finishLine = _finishLine;
    }

    function joinRace() external {
        require(!raceStarted, "Race already started");
        for (uint i = 0; i < players.length; i++) {
            require(players[i].addr != msg.sender, "Already joined");
        }
        players.push(Player({addr: msg.sender, position: 0}));
    }

    function startRace() external {
        require(!raceStarted, "Race already started");
        require(players.length >= 2, "Need at least 2 players");
        raceStarted = true;
    }

    function moveForward() external {
        require(raceStarted, "Race not started");
        require(!raceFinished, "Race finished");

        for (uint i = 0; i < players.length; i++) {
            if (players[i].addr == msg.sender) {
                players[i].position += 1;

                if (players[i].position >= finishLine) {
                    raceFinished = true;
                    winner = msg.sender;
                }
                return;
            }
        }
        revert("Not a player");
    }

    function getMyPosition() external view returns (uint256) {
        for (uint i = 0; i < players.length; i++) {
            if (players[i].addr == msg.sender) {
                return players[i].position;
            }
        }
        revert("Not a player");
    }

    function getPlayers() external view returns (Player[] memory) {
        return players;
    }
}
