// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AudioRegistry {
    struct AudioAsset {
        string title;
        bytes32 contentHash;
        string infoHash; // WebTorrent P2P magnet/infoHash
        address creator;
        uint256 timestamp;
    }

    mapping(bytes32 => AudioAsset) public assets;
    event AssetRegistered(bytes32 indexed contentHash, string title, address indexed creator);

    function registerAsset(string memory _title, bytes32 _contentHash, string memory _infoHash) public {
        require(assets[_contentHash].timestamp == 0, "Asset already registered");
        assets[_contentHash] = AudioAsset({
            title: _title,
            contentHash: _contentHash,
            infoHash: _infoHash,
            creator: msg.sender,
            timestamp: block.timestamp
        });
        emit AssetRegistered(_contentHash, _title, msg.sender);
    }

    function verifyAsset(bytes32 _contentHash) public view returns (bool, string memory, address) {
        AudioAsset memory asset = assets[_contentHash];
        return (asset.timestamp != 0, asset.title, asset.creator);
    }
}