module todolist::todolist {

    use sui::object::{Self, UID};
    use std::vector;
    use std::string::String;
    use sui::table::{Self, Table};

    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    
    struct TodoObject has store{
        id: UID,
        taskID: u64,
        taskName: String,
        checked: bool,
        deleted: bool
    } 


    fun init(ctx: &mut TxContext){
        let userTable = table::new<address, vector<TodoObject>>(ctx);
        transfer::public_share_object(userTable); 
        // The object needs to be shared otherwise only the owner can modify the table object
        // If it's a shared object, people should be allowed to change only their mapping
    }

    entry public fun addTask(taskName: String, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext){

        // Get user from TxContext
        let user = tx_context::sender(ctx);

        // Add a mapping for the user if it doesn't exist
        if(!table::contains(userTable, user)){
            
            table::add(userTable, user, vector::empty<TodoObject>());

        };
        
        // Get Length of User's todoObjects
        let userTasks = table::borrow(userTable, user); 
        let length = vector::length<TodoObject>(userTasks);

        // Append task to user mapping
        let taskObject = TodoObject{
            id: object::new(ctx),
            taskID: length, 
            taskName,
            checked: false,
            deleted: false
            };

        let taskEntry = vector::singleton<TodoObject>(taskObject);
        vector::append(table::borrow_mut(userTable, user), taskEntry);
    }

    entry public fun editTask(taskID: u64, taskName: String, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext){
        
        // Get user from TxContext
        let user = tx_context::sender(ctx);

        // Edit task name
        let userTasks = table::borrow_mut(userTable, user);
        let task = vector::borrow_mut<TodoObject>(userTasks, taskID);
        task.taskName = taskName;
    }

    entry public fun checkTask(taskID: u64, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext){
        
        // Get user from TxContext
        let user = tx_context::sender(ctx);

        // Mark task as checked
        let userTasks = table::borrow_mut(userTable, user);
        let task = vector::borrow_mut<TodoObject>(userTasks, taskID);
        task.checked = !task.checked;
    }

    entry public fun deleteTask(taskID: u64, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext){
        
        // Get user from TxContext
        let user = tx_context::sender(ctx);

        // Mark task as deleted
        let userTasks = table::borrow_mut(userTable, user);
        let task = vector::borrow_mut<TodoObject>(userTasks, taskID);
        task.deleted = !task.deleted;
    }

    public fun get_TodoObject(self : &TodoObject):(u64, String, bool, bool) {
        (self.taskID, self.taskName, self.checked, self.deleted)
    }


    public fun retrieveTasks(userTable: &Table<address, vector<TodoObject>>, ctx: &mut TxContext): &vector<TodoObject>{
         
         // Get user from TxContext
        let user = tx_context::sender(ctx);

        table::borrow(userTable, user)
        
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(ctx)
    }
}


