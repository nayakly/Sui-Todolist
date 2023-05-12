#[test_only]
module todolist::todolist_tests{

    use todolist::todolist::{Self, TodoObject};
    use sui::test_scenario;
    use sui::table::{Table};
    use std::vector;
    use std::string;

    #[test]
    fun test_todolist(){

        let owner = @0x1;
        let user = @0x2;

        let scenario_val = test_scenario::begin(owner);
        let scenario = &mut scenario_val;
        {   
            // Get TxContext
            let ctx = test_scenario::ctx(scenario);
            
            todolist::init_for_testing(ctx);
        };
        test_scenario::next_tx(scenario, user);
        {   
            //Get Shared Object userTable
            let userTable = test_scenario::take_shared<Table<address,vector<TodoObject>>>(scenario);
            let ctx = test_scenario::ctx(scenario);
            
            
            // Add Task 
            todolist::addTask(string::utf8(b"task 1"), &mut userTable, ctx); 

            let userTasks = todolist::retrieveTasks(&userTable, ctx);
            let task = vector::borrow<TodoObject>(userTasks, 0);
          
            let (taskID, taskName, checked, deleted) = todolist::get_TodoObject(task);
            assert!(taskID == 0, 100);
            assert!(taskName == string::utf8(b"task 1"), 100); 
            assert!(checked == false, 100);
            assert!(deleted == false, 100);

            // Edit Task 
            todolist::editTask(0, string::utf8(b"Task #1"), &mut userTable, ctx); 

            let userTasks = todolist::retrieveTasks(&userTable, ctx);
            let task = vector::borrow<TodoObject>(userTasks, 0);
          
            (taskID, taskName, checked, deleted) = todolist::get_TodoObject(task);
            assert!(taskID == 0, 100);
            assert!(taskName == string::utf8(b"Task #1"), 100); 
            assert!(checked == false, 100);
            assert!(deleted == false, 100);

            // Check Task 
            todolist::checkTask(0, &mut userTable, ctx); 

            let userTasks = todolist::retrieveTasks(&userTable, ctx);
            let task = vector::borrow<TodoObject>(userTasks, 0);
          
            (taskID, taskName, checked, deleted) = todolist::get_TodoObject(task);
            assert!(taskID == 0, 100);
            assert!(taskName == string::utf8(b"Task #1"), 100); 
            assert!(checked == true, 100);
            assert!(deleted == false, 100);

            // Delete Task 
            todolist::deleteTask(0, &mut userTable, ctx); 

            let userTasks = todolist::retrieveTasks(&userTable, ctx);
            let task = vector::borrow<TodoObject>(userTasks, 0);
          
            (taskID, taskName, checked, deleted) = todolist::get_TodoObject(task);
            assert!(taskID == 0, 100);
            assert!(taskName == string::utf8(b"Task #1"), 100); 
            assert!(checked == true, 100);
            assert!(deleted == true, 100);

            test_scenario::return_shared(userTable);
        };
           test_scenario::end(scenario_val); 
    }

}