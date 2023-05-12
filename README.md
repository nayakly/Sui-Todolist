# **To-do List Smart Contract**


This is a smart contract for a to-do list built using the Sui Move programming language. The contract allows users to add, edit, check, and delete tasks on their personal to-do list.

## **Overview**

The contract is designed to be used with a table data structure that maps user addresses to a vector of **`TodoObject`**. Each **`TodoObject`** represents a single task on a user's todo list and has the following fields:

- **`id`**: A unique identifier for the task based on `UID`
- **`taskID`**: A numerical ID that represents the task's position in the user's list.
- **`taskName`**: A string that represents the name of the task.
- **`checked`**: A boolean that represents whether the task has been checked off or not.
- **`deleted`**: A boolean that represents whether the task has been deleted or not.

The contract includes the following functions:

### **`init`**

This function is called when the contract is first deployed and initializes the user table. It takes a mutable reference to a **`TxContext`** as an argument.

### **`addTask`**

This function allows users to add a new task to their to-do list. It takes a **`taskName`** string, a mutable reference to the user table, and a mutable reference to a **`TxContext`** as arguments. It adds a new **`TodoObject`** to the user's vector in the table.

```rust
entry public fun addTask(taskName: String, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext)
```

### **`editTask`**

This function allows users to edit the name of an existing task on their to-do list. It takes a **`taskID`** u64, a **`taskName`** string, a mutable reference to the user table, and a mutable reference to a **`TxContext`** as arguments. It updates the **`taskName`** field of the **`TodoObject`** at the specified index in the user's vector.

```rust
entry public fun editTask(taskID: u64, taskName: String, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext)
```

### **`checkTask`**

This function allows users to check or uncheck an existing task on their to-do list. It takes a **`taskID`** u64, a mutable reference to the user table, and a mutable reference to a **`TxContext`** as arguments. It toggles the **`checked`** field of the **`TodoObject`** at the specified index in the user's vector.

```rust
entry public fun checkTask(taskID: u64, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext)
```

### **`deleteTask`**

This function allows users to delete an existing task on their to-do list. It takes a **`taskID`** u64, a mutable reference to the user table, and a mutable reference to a **`TxContext`** as arguments. It toggles the **`deleted`** field of the **`TodoObject`** at the specified index in the user's vector.

```rust
entry public fun deleteTask(taskID: u64, userTable: &mut Table<address, vector<TodoObject>>, ctx: &mut TxContext)
```

### **`retrieveTasks`**

This function allows users to retrieve their entire todo list. It takes a reference to the user table and a mutable reference to a **`TxContext`** as arguments. It returns a reference to the user's vector in the table.

```rust
public fun retrieveTasks(userTable: &Table<address, vector<TodoObject>>, ctx: &mut TxContext): &vector<TodoObject>
```

### **`get_TodoObject`**

This function allows a user to retrieve the details of a single **`TodoObject`**. It takes a mutable reference to a **`TodoObject`** as an argument and returns a tuple containing the **`taskID`**, **`taskName`**, **`checked`**, and **`deleted`** fields.

```rust
public fun get_TodoObject(self : &TodoObject):(u64, String, bool, bool)
```

### **`init_for_testing`**

This function is used for testing purposes only and simply calls the **`init`** function. It takes a mutable reference to a **`TxContext`** as an argument and is marked with the **`#[test_only]`** attribute.


## **Contract Compilation & Testing**

To compile the contract, execute the following command in the root directory of the project:

```rust
    sui move build
```

This will generate the compiled bytecode of the contract. To test the contract, there are test cases located in `./tests/todolist_tests.move`. You can run the tests by executing the following command in the root directory of the project:

```rust
    sui move test
```

## **Deployment**

To deploy the smart contract, please follow these steps:

1. Set your Sui client to the desired network (mainnet/testnet/devnet).
2. Navigate to the root directory of the smart contract.
3. Ensure that you have sufficient gas balance for the deployment.
4. Type the following command, replacing `<gas-value>` with the desired amount of gas

    ```rust
    sui client --publish --gas-budget <gas-value>
    ```

## **Usage**

The contract is designed to be used in conjunction with a user interface, such as a web application. When a user performs an action on their to-do list, such as adding or editing a task, the user interface should call the corresponding function on the smart contract.