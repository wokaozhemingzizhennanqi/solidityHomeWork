// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
        部署时候传入地址参数和需要的签名数
        多个 owner 地址 "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"
        发起交易的最低签名数
        有接受 ETH 主币的方法，
        除了存款外，其他所有方法都需要 owner 地址才可以触发
        发送前需要检测是否获得了足够的签名数
        使用发出的交易数量值作为签名的凭据 ID（类似上么）
        每次修改状态变量都需要抛出事件
        允许批准的交易，在没有真正执行前取消。
        足够数量的 approve 后，才允许真正执行。


*/
contract MultiSignWallet {
    address[] public owners;
    mapping(address => bool) public isOwner;

    uint256 public required;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool exected; //是否执行
    }
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public approved; //交易批准记录

    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Approve(address indexed owner, uint256 indexed txId);
    event Revoke(address indexed owner, uint256 indexed txId);
    event Execute(uint256 indexed txId);

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "is not owner");
        _;
    }
    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "tx doesn't exist");
        _;
    }
    modifier notApproved(uint256 _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }
    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].exected, "tx is exected");
        _;
    }

    // owners_ 可提取金额的地址  required 最多owner人数
    constructor(address[] memory owners_, uint256 required_) {
        uint256 ownerLength = owners_.length;

        require(ownerLength > 0, "owners required");
        require(
            required <= ownerLength,
            "required must be greater than owners count"
        );

        uint8 i = 0;
        for (i; i < ownerLength; i++) {
            address ads = owners_[i];
            require(ads != address(0), " invalid owner address");
            require(!isOwner[ads], "owner is not unique");
            owners.push(ads);
            isOwner[ads] = true;
        }
        required = required_;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function promoteTrade(
        address to_,
        uint256 value_,
        bytes calldata data_
    ) external onlyOwner returns (uint256) {
        transactions.push(
            Transaction({to: to_, value: value_, data: data_, exected: false})
        );
        emit Submit(transactions.length - 1);
        return transactions.length - 1;
    }

    function approve(uint256 txId_)
        external
        onlyOwner
        txExists(txId_)
        notApproved(txId_)
        notExecuted(txId_)
    {
        approved[txId_][msg.sender] = true;
        emit Approve(msg.sender, txId_);
    }

    function revoke(uint256 txId_)
        external
        onlyOwner
        txExists(txId_)
        notExecuted(txId_)
    {
        approved[txId_][msg.sender] = false;
        emit Revoke(msg.sender, txId_);
    }

    function execute(uint256 txId_)
        external
        onlyOwner
        txExists(txId_)
        notExecuted(txId_)
    {
        require(
            getApprovalCount(txId_) >= required,
            "approval count must greater than required"
        );
        Transaction storage transaction = transactions[txId_];
        transaction.exected = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );
        require(success, "execute transfor failed");
        emit Execute(txId_);
    }


    function getApprovalCount(uint256 txId_)
        private
        view
        returns (uint256 count)
    {
        for (uint8 i = 0; i < owners.length; i++) {
            if (approved[txId_][owners[i]]) {
                count++;
            }
        }
        return count;
    }
}
