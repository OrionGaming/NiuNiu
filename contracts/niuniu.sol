pragma solidity ^0.4.23;
contract Niuniu {

    string public name;
    mapping(bytes32 => string) public gamexcards;
    address public owner;

    constructor(string contract_name) public {
        owner = msg.sender;
        name = contract_name;
    }

    modifier isOwner() {
        address _addr = msg.sender;

        require(_addr == owner, "sorry owner only");
        _;
    }

    event shuffledCards(string game, bytes32 gameindex, string cards, bytes32 seed1, bytes32 seed2);

    function shuffle(string game, uint8 round, address[] memory players) isOwner() public {
        bytes32 seed1 = keccak256(abi.encodePacked(block.timestamp + block.difficulty + uint256(keccak256(abi.encodePacked(block.coinbase))) / now + block.gaslimit + uint256(keccak256(abi.encodePacked(msg.sender))) / now + block.number));
        bytes32 seed2 = keccak256(abi.encodePacked(block.timestamp + block.difficulty + uint256(keccak256(abi.encodePacked(block.coinbase))) / now + block.gaslimit + uint256(keccak256(abi.encodePacked(msg.sender))) / now));

        string memory cards = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        uint8 start = 0;
        uint8 left = 52;
        uint8 num = (uint8)(players.length);

        bytes32 gameindex = keccak256(abi.encodePacked(game));

        if (round == 2 || round == 3) {

            cards = gamexcards[gameindex];

            start = num * (round + 1);
            left = 52 - start;
        }

        for (uint8 i = 0; i < left; i++) {
            uint8 random = 0;
            if (i < 32) {
                random = uint8(seed1[i]) % left;
            } else {
                random = uint8(seed2[i - 32]) % left;
            }

            bytes1 tmp = bytes(cards)[i + start];
            bytes(cards)[i + start] = bytes(cards)[random + start];
            bytes(cards)[random + start] = tmp;

        }

        gamexcards[gameindex] = cards;

        emit shuffledCards(game, gameindex, cards, seed1, seed2);
    }
}
