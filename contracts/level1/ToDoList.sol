// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
TodoList: 是类似便签一样功能的东西，记录我们需要做的事情，以及完成状态。 1.需要完成的功能

1、创建任务
2、修改任务名称
    任务名写错的时候
3、 修改完成状态：
    手动指定完成或者未完成
    自动切换
    如果未完成状态下，改为完成
    如果完成状态，改为未完成
4、 获取任务 2.思考代码内状态变量怎么安排？ 思考 1：思考任务 ID 的来源？ 我们在传统业务里，这里的任务都会有一个任务 ID，在区块链里怎么实现？？ 答：传统业务里，ID 可以是数据库自动生成的，也可以用算法来计算出来的，比如使用雪花算法计算出 ID 等。在区块链里我们使用数组的 index 索引作为任务的 ID，也可以使用自增的整型数据来表示。 思考 2: 我们使用什么数据类型比较好？ 答：因为需要任务 ID，如果使用数组 index 作为任务 ID。则数据的元素内需要记录任务名称，任务完成状态，所以元素使用 struct 比较好。 如果使用自增的整型作为任务 ID，则整型 ID 对应任务，使用 mapping 类型比较符合。 3.演示代码

*/
contract ToDoList {
    struct Task {
        string name;
        Status status;
    }
    enum Status {
        inComplete,
        // doing,
        completed,
        canceled
    }

    Task[] public todoList;

    //创建任务
    function createTask(string memory taskName) external  {
        todoList.push(Task({name: taskName, status: Status.inComplete}));
    }

    //修改任务名称
    function modifyName(uint256 index, string memory name) public {
        todoList[index].name=name;
    }

    //修改完成状态 1 手动指定完成或者未完成
   function modifyState(uint256 index, Status status) public {
        todoList[index].status=status;
    }
    //修改完成状态 2 如果未完成状态下，改为完成  如果完成状态，改为未完成

    function modifyState(uint256 index) public {
        Status nextStatus = getNextStatus(todoList[index].status);
        todoList[index].status=nextStatus;
    }

    function getNextStatus(Status status) internal  pure returns(Status nextStatus){
        if(status==Status.inComplete){
            return Status.completed;
        }else if(status==Status.completed){
            return Status.inComplete;
        }else {
            return Status.canceled;
        }
    }

    function getTaskByIndex(uint256 idx) public view returns (Task memory task){
        return  todoList[idx];
    }

        function getTaskInfo(uint256 idx) public view returns (string memory name,Status status){
        Task storage task =  todoList[idx];
        return (task.name,task.status);
    }
}
