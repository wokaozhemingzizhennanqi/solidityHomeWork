// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
    众筹合约分为两种角色：一个是受益人，一个是资助者。

    // 两种角色:
    //      受益人   beneficiary => address         => address 类型
    //      资助者   funders     => address:amount  => mapping 类型 或者 struct 类型
    状态变量按照众筹的业务：
    // 状态变量
    //      筹资目标数量    fundingGoal
    //      当前募集数量    fundingAmount
    //      资助者列表      funders
    //      资助者人数      fundersKey
    需要部署时候传入的数据:
    //      受益人
    //      筹资目标数量
*/
contract CrowdFunding{
    address public immutable beneficiary; //受益人
    uint256 public immutable goal; //目标数量

    uint256 public  fundingAmount; //当前的金额
    mapping(address=>uint256) public funders;  //资助者
    mapping(address=>bool) private funderInserted; //是否资助过
    uint64 public fundersCount=0; //资助者计数器

    bool public AVAILABLED=true; //状态
    // 受益人+筹资目标数量
    constructor(address beneficiary_,uint256 goal_){
        beneficiary=beneficiary_;
        goal=goal_;
    }

    // 资助
    function contribute() external payable{
        require(AVAILABLED,"Funding is closed");
        address sender = msg.sender;
        funders[sender] += msg.value;
        fundingAmount += msg.value;

        if(!funderInserted[sender]){
            fundersCount++;
            funderInserted[sender]=true;
        }
    }

    // 关闭
    function closeFund() external  returns(bool){
        if(fundingAmount<goal){
            return false;
        }
        AVAILABLED=false;
        uint256 amount = fundingAmount;
        payable(beneficiary).transfer(amount);
        fundingAmount=0;
        return true;
    }
}