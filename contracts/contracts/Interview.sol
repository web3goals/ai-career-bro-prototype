// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import "@tableland/evm/contracts/utils/SQLHelpers.sol";

/**
 * @notice A contract that stores interviews
 */
contract Interview is ERC721, Ownable {
    using Counters for Counters.Counter;

    string private _imageSVG;
    Counters.Counter private _counter;
    mapping(uint => string) private _topics;
    uint public _tableId;
    string private constant _TABLE_PREFIX = "interview_messages";

    constructor() ERC721("AI Career Bro - Interviews", "AICBI") {
        // Init image
        _imageSVG = '<svg width="256" height="256" viewBox="0 0 256 256" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="256" height="256" fill="#EEEEEE"/><path d="M45.8173 157.836H52.1893V183H45.8173V157.836ZM55.4149 165.72H61.5349V167.628C62.2789 166.812 63.1789 166.2 64.2349 165.792C65.2909 165.384 66.3949 165.18 67.5469 165.18C69.9709 165.18 71.7589 165.816 72.9109 167.088C74.0869 168.336 74.6749 170.04 74.6749 172.2V183H68.3389V173.028C68.3389 171.084 67.4509 170.112 65.6749 170.112C64.8589 170.112 64.1149 170.304 63.4429 170.688C62.7709 171.048 62.2069 171.612 61.7509 172.38V183H55.4149V165.72ZM85.2271 183.54C83.0911 183.54 81.4711 182.952 80.3671 181.776C79.2871 180.576 78.7471 178.944 78.7471 176.88V170.112H76.2991V165.72H78.7471V160.536H85.0831V165.72H89.0431V170.112H85.0831V176.016C85.0831 176.952 85.2511 177.624 85.5871 178.032C85.9471 178.44 86.5711 178.644 87.4591 178.644C88.2511 178.644 89.0431 178.428 89.8351 177.996V182.712C89.2111 183 88.5391 183.204 87.8191 183.324C87.1231 183.468 86.2591 183.54 85.2271 183.54ZM101.778 183.54C98.3939 183.54 95.7299 182.748 93.7859 181.164C91.8659 179.58 90.9059 177.336 90.9059 174.432C90.9059 171.576 91.7579 169.32 93.4619 167.664C95.1899 166.008 97.6739 165.18 100.914 165.18C102.978 165.18 104.742 165.576 106.206 166.368C107.694 167.136 108.81 168.204 109.554 169.572C110.322 170.916 110.706 172.44 110.706 174.144V176.484H96.9179C97.1579 177.444 97.7579 178.14 98.7179 178.572C99.6779 179.004 100.986 179.22 102.642 179.22C103.77 179.22 104.922 179.124 106.098 178.932C107.298 178.74 108.33 178.476 109.194 178.14V182.316C108.306 182.676 107.19 182.964 105.846 183.18C104.526 183.42 103.17 183.54 101.778 183.54ZM104.73 172.524C104.634 171.588 104.25 170.856 103.578 170.328C102.906 169.8 101.982 169.536 100.806 169.536C99.6539 169.536 98.7419 169.812 98.0699 170.364C97.3979 170.892 97.0139 171.612 96.9179 172.524H104.73ZM113.212 165.72H119.332V167.88C120.004 167.112 120.952 166.524 122.176 166.116C123.4 165.684 124.756 165.468 126.244 165.468V170.328C124.66 170.328 123.256 170.556 122.032 171.012C120.832 171.468 120.004 172.152 119.548 173.064V183H113.212V165.72ZM127.152 165.72H133.488L137.412 175.764L141.3 165.72H147.636L140.4 183H134.388L127.152 165.72ZM153.545 163.416C152.585 163.416 151.781 163.104 151.133 162.48C150.485 161.856 150.161 161.064 150.161 160.104C150.161 159.168 150.485 158.388 151.133 157.764C151.781 157.116 152.585 156.792 153.545 156.792C154.481 156.792 155.273 157.116 155.921 157.764C156.593 158.388 156.929 159.168 156.929 160.104C156.929 161.04 156.593 161.832 155.921 162.48C155.273 163.104 154.481 163.416 153.545 163.416ZM150.377 165.72H156.713V183H150.377V165.72ZM170.333 183.54C166.949 183.54 164.285 182.748 162.341 181.164C160.421 179.58 159.461 177.336 159.461 174.432C159.461 171.576 160.313 169.32 162.017 167.664C163.745 166.008 166.229 165.18 169.469 165.18C171.533 165.18 173.297 165.576 174.761 166.368C176.249 167.136 177.365 168.204 178.109 169.572C178.877 170.916 179.261 172.44 179.261 174.144V176.484H165.473C165.713 177.444 166.313 178.14 167.273 178.572C168.233 179.004 169.541 179.22 171.197 179.22C172.325 179.22 173.477 179.124 174.653 178.932C175.853 178.74 176.885 178.476 177.749 178.14V182.316C176.861 182.676 175.745 182.964 174.401 183.18C173.081 183.42 171.725 183.54 170.333 183.54ZM173.285 172.524C173.189 171.588 172.805 170.856 172.133 170.328C171.461 169.8 170.537 169.536 169.361 169.536C168.209 169.536 167.297 169.812 166.625 170.364C165.953 170.892 165.569 171.612 165.473 172.524H173.285ZM181.046 165.72H187.382L190.154 175.62L192.926 165.72H198.038L200.81 175.62L203.582 165.72H209.918L204.122 183H198.434L195.482 173.28L192.53 183H186.842L181.046 165.72Z" fill="black"/><path d="M103.486 206.28H105.95L107.028 210.13L108.106 206.28H110.094L111.172 210.13L112.25 206.28H114.714L112.46 213H110.248L109.1 209.22L107.952 213H105.74L103.486 206.28ZM119.398 203.004H121.918L117.928 213H115.408L119.398 203.004ZM127.651 203.214H132.607C133.549 203.214 134.291 203.447 134.833 203.914C135.383 204.381 135.659 205.048 135.659 205.916C135.659 206.327 135.565 206.709 135.379 207.064C135.192 207.419 134.926 207.699 134.581 207.904C135.057 208.091 135.407 208.361 135.631 208.716C135.855 209.061 135.967 209.514 135.967 210.074C135.967 210.671 135.827 211.194 135.547 211.642C135.267 212.081 134.889 212.417 134.413 212.65C133.946 212.883 133.423 213 132.845 213H127.651V203.214ZM132.061 207.092C132.789 207.092 133.153 206.751 133.153 206.07C133.153 205.687 133.059 205.426 132.873 205.286C132.686 205.137 132.401 205.062 132.019 205.062H130.129V207.092H132.061ZM132.215 211.152C132.635 211.152 132.947 211.073 133.153 210.914C133.358 210.755 133.461 210.475 133.461 210.074C133.461 209.673 133.353 209.383 133.139 209.206C132.924 209.019 132.597 208.926 132.159 208.926H130.129V211.152H132.215ZM136.947 206.28H139.327V207.12C139.589 206.821 139.957 206.593 140.433 206.434C140.909 206.266 141.437 206.182 142.015 206.182V208.072C141.399 208.072 140.853 208.161 140.377 208.338C139.911 208.515 139.589 208.781 139.411 209.136V213H136.947V206.28ZM146.376 213.21C145.545 213.21 144.817 213.061 144.192 212.762C143.567 212.454 143.081 212.034 142.736 211.502C142.4 210.961 142.232 210.34 142.232 209.64C142.232 208.94 142.4 208.324 142.736 207.792C143.081 207.251 143.567 206.831 144.192 206.532C144.817 206.224 145.545 206.07 146.376 206.07C147.207 206.07 147.935 206.224 148.56 206.532C149.185 206.831 149.666 207.251 150.002 207.792C150.347 208.324 150.52 208.94 150.52 209.64C150.52 210.34 150.347 210.961 150.002 211.502C149.666 212.034 149.185 212.454 148.56 212.762C147.935 213.061 147.207 213.21 146.376 213.21ZM146.376 211.292C146.871 211.292 147.263 211.147 147.552 210.858C147.851 210.559 148 210.153 148 209.64C148 209.127 147.851 208.725 147.552 208.436C147.263 208.137 146.871 207.988 146.376 207.988C145.881 207.988 145.485 208.137 145.186 208.436C144.897 208.725 144.752 209.127 144.752 209.64C144.752 210.153 144.897 210.559 145.186 210.858C145.485 211.147 145.881 211.292 146.376 211.292Z" fill="#999999"/><path d="M145.819 127.566L163.558 109.822L137.134 78.7723C136.049 84.1013 133.436 89.1796 129.307 93.3098C125.177 97.44 120.099 100.049 114.771 101.134L145.817 127.566H145.819ZM165.96 112.641L148.639 129.964L151.476 132.378C153.653 134.234 156.362 135.098 159.027 134.991C161.684 134.884 164.308 133.806 166.334 131.78L167.777 130.33C169.806 128.3 170.888 125.68 170.991 123.022C171.098 120.358 170.234 117.648 168.378 115.471L165.965 112.633L165.96 112.641ZM138.029 104.635C137.309 103.92 137.306 102.753 138.021 102.033C138.737 101.313 139.903 101.31 140.623 102.026L145.077 106.48C145.797 107.196 145.8 108.362 145.085 109.082C144.369 109.802 143.203 109.805 142.483 109.09L138.029 104.635ZM128.918 57.868C126.963 66.6037 122.563 74.3911 116.475 80.4795C110.39 86.5652 102.6 90.9647 93.8662 92.9205C98.3278 96.3229 103.675 98.0324 109.011 98.0324C115.413 98.0247 121.816 95.5817 126.698 90.6989C131.58 85.8161 134.023 79.4129 134.023 73.013C134.023 67.6729 132.322 62.3285 128.92 57.8664L128.918 57.868ZM90.4919 89.8246C99.5662 88.3666 107.669 84.071 113.87 77.871C120.069 71.671 124.365 63.5662 125.822 54.495C121.065 50.1693 115.036 48.0033 109.009 48C102.617 47.9966 96.2114 50.4395 91.325 55.3258C86.4428 60.2051 84 66.6083 84 73.015C84 79.0417 86.1665 85.069 90.491 89.8255L90.4919 89.8246Z" fill="black"/></svg>';
        // Init table
        _tableId = TablelandDeployments.get().create(
            address(this),
            SQLHelpers.toCreateFromSchema(
                "id text primary key,"
                "interview integer,"
                "timestamp integer,"
                "role text,"
                "content text,"
                "points integer",
                _TABLE_PREFIX
            )
        );
    }

    /// ***************************
    /// ***** OWNER FUNCTIONS *****
    /// ***************************

    function setImageSVG(string memory imageSVG) public onlyOwner {
        _imageSVG = imageSVG;
    }

    /// **************************
    /// ***** USER FUNCTIONS *****
    /// **************************

    function start(string memory topic) public {
        // Checks
        if (isStarted(msg.sender, topic)) {
            revert("Interview is already started");
        }
        // Update counter
        _counter.increment();
        // Mint token
        uint tokenId = _counter.current();
        _mint(msg.sender, tokenId);
        // Set topic
        _topics[tokenId] = topic;
    }

    function saveMessages(
        uint tokenId,
        uint[] memory messageTimestamps,
        string[] memory messageRoles,
        string[] memory messageContents,
        uint[] memory messagePoints
    ) public {
        // Checks
        if (ownerOf(tokenId) != msg.sender) {
            revert("Not interview owner");
        }
        // Save messages in table
        for (uint i = 0; i < messageTimestamps.length; i++) {
            TablelandDeployments.get().mutate(
                address(this),
                _tableId,
                SQLHelpers.toInsert(
                    _TABLE_PREFIX,
                    _tableId,
                    "id,interview,timestamp,role,content,points",
                    string.concat(
                        SQLHelpers.quote(
                            string.concat(
                                Strings.toString(tokenId),
                                "_",
                                Strings.toString(messageTimestamps[i])
                            )
                        ),
                        ",",
                        Strings.toString(tokenId),
                        ",",
                        Strings.toString(messageTimestamps[i]),
                        ",",
                        SQLHelpers.quote(messageRoles[i]),
                        ",",
                        SQLHelpers.quote(messageContents[i]),
                        ",",
                        Strings.toString(messagePoints[i])
                    )
                )
            );
        }
    }

    /// *********************************
    /// ***** PUBLIC VIEW FUNCTIONS *****
    /// *********************************

    function getCounterCurrent() public view returns (uint) {
        return _counter.current();
    }

    function getImageSVG() public view returns (string memory) {
        return _imageSVG;
    }

    function getTopic(uint tokenId) public view returns (string memory) {
        return _topics[tokenId];
    }

    function isStarted(
        address owner,
        string memory topic
    ) public view returns (bool) {
        uint tokenId = find(owner, topic);
        return tokenId != 0;
    }

    function find(
        address owner,
        string memory topic
    ) public view returns (uint) {
        uint tokenId;
        for (uint i = 1; i <= _counter.current(); i++) {
            if (ownerOf(i) == owner && Strings.equal(_topics[i], topic)) {
                tokenId = i;
            }
        }
        return tokenId;
    }

    function tokenURI(
        uint tokenId
    ) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"name":"AI Career Bro - Interview #',
                            Strings.toString(tokenId),
                            '","image":"data:image/svg+xml;base64,',
                            Base64.encode(abi.encodePacked(_imageSVG)),
                            '","attributes":[{"trait_type":"topic","value":"',
                            _topics[tokenId],
                            '"}]}'
                        )
                    )
                )
            );
    }

    /// ******************************
    /// ***** INTERNAL FUNCTIONS *****
    /// ******************************

    /**
     * @notice A function that is called before any token transfer
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint firstTokenId,
        uint batchSize
    ) internal virtual override(ERC721) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
        // Disable transfers except minting
        if (from != address(0)) revert("Token is not transferable");
    }
}
