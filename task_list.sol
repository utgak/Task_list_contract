pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {
    uint8 numberOfTasks;
    struct task {
        uint32 timestamp;
        string name;
        bool completed;
    }
    mapping (uint8 => task) task_m;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    function addTask(string name) public checkOwnerAndAccept {
        require(!name.empty(), 228);
        task_m[numberOfTasks] = task(now, name, false);
        numberOfTasks += 1;
    }

    function openTasks() public view returns (uint) {
        uint count;
        for (uint8 i; i < numberOfTasks; i++) {
            if (task_m[i].completed == false) { count += 1; }
        }
        return count;
    }

    function tasksList() public view returns (string[]) {
        string[] tasks;
        for (uint8 i = 0; i < numberOfTasks; i++) {
            tasks.push(task_m[i].name);
        }
        return tasks;
    }

    function getTask(uint8 i) public view returns (task) {
        require(i < numberOfTasks, 1337);
        return task_m[i];
    }

    function deleteTask(uint8 i) public checkOwnerAndAccept {
        require(i < numberOfTasks, 1337);
        delete task_m[i];
    }

    function completeTask(uint8 i) public checkOwnerAndAccept {
        require(i < numberOfTasks, 1337);
        task_m[i].completed = true;
    }
}
