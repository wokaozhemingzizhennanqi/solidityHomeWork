// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
        WETH 是包装 ETH 主币，作为 ERC20 的合约。 标准的 ERC20 合约包括如下几个

        3 个查询
        balanceOf: 查询指定地址的 Token 数量
        allowance: 查询指定地址对另外一个地址的剩余授权额度
        totalSupply: 查询当前合约的 Token 总量
        2 个交易
        transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
        这是一个写入方法，所以还会抛出一个 Transfer 事件。
        transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
        2 个事件
        Transfer
        Approval
        1 个授权
        approve: 授权指定地址可以操作调用者的最大 Token 数量。
*/
contract WETH {
    string public constant name = "Wrapper Ether";
    string public constant symbolName = "WETH";
    uint8 public constant decimals = 18;

    //event
    event Approval(
        address indexed src,
        address indexed delegateAds,
        uint256 amount
    );

    event Transfer(address indexed src, address indexed toAds, uint256 amount);

    event Deposit(address indexed toAds, uint256 amount);

    event Withdrow(address indexed toAds, uint256 amount);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdrow(uint256 amount_) public payable {
        require(balanceOf[msg.sender] >= amount_, "Insufficient balance");
        //改状态
        balanceOf[msg.sender] -= amount_;
        //转账
        payable(msg.sender).transfer(amount_);
        emit Withdrow(msg.sender, msg.value);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address delegateAds, uint256 amount_)
        public
        returns (bool)
    {
        allowance[msg.sender][delegateAds] = amount_;
        emit Approval(msg.sender, delegateAds, amount_);

        return true;
    }

    function transfer(address toAds, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender,toAds,amount);
    }

    function transferFrom(
        address src,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[src] >= amount, "Insufficient balance");
        //授权转账 判断额度
        uint256 maxAmount = allowance[src][toAds];
        if (src != msg.sender) {
            require(maxAmount >= amount, "Transfer exceeds limit");
        }

        balanceOf[src] -= amount;
        balanceOf[toAds] += amount;
        // payable(src).transfer(toAds, amount);
        emit Transfer(src, toAds, amount);
        return true;
    }

    receive() external payable {
        deposit();
     }


}

