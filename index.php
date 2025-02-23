<?php
$host = "localhost";
$user = "root";
$password = "";
$dbname = "employee_db";

// Create connection
$conn = new mysqli($host, $user, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (isset($_POST['save'])) {
        $employee_id = $_POST['employee_id'];
        $employee_designation = $_POST['employee_designation'];
        $employee_salary = $_POST['employee_salary'];

        $sql = "INSERT INTO employees (employee_id, employee_designation, employee_salary) VALUES ('$employee_id', '$employee_designation', '$employee_salary')";
        if ($conn->query($sql) === TRUE) {
            echo "Record added successfully";
        } else {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    } elseif (isset($_POST['update'])) {
        $employee_id = $_POST['employee_id'];
        $employee_designation = $_POST['employee_designation'];
        $employee_salary = $_POST['employee_salary'];

        $sql = "UPDATE employees SET employee_designation='$employee_designation', employee_salary='$employee_salary' WHERE employee_id='$employee_id'";
        if ($conn->query($sql) === TRUE) {
            echo "Record updated successfully";
        } else {
            echo "Error updating record: " . $conn->error;
        }
    } elseif (isset($_POST['delete'])) {
        $employee_id = $_POST['employee_id'];

        $sql = "DELETE FROM employees WHERE employee_id='$employee_id'";
        if ($conn->query($sql) === TRUE) {
            echo "Record deleted successfully";
        } else {
            echo "Error deleting record: " . $conn->error;
        }
    }
}

// Fetch employee records
$result = $conn->query("SELECT * FROM employees");
?>

<!DOCTYPE html>
<html>
<head>
    <title>Employee Management</title>
</head>
<body>

<h2>Employee Management Form</h2>

<form method="POST" action="">
    <input type="hidden" name="id" value="">
    <label>Employee ID:</label>
    <input type="text" name="employee_id" required><br><br>

    <label>Employee Designation:</label>
    <input type="text" name="employee_designation" required><br><br>

    <label>Employee Salary:</label>
    <input type="text" name="employee_salary" required><br><br>

    <button type="submit" name="save">Save</button>
    <button type="submit" name="update">Update</button>
    <button type="submit" name="delete">Delete</button>
</form>

<h2>Employee Records</h2>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Employee ID</th>
        <th>Designation</th>
        <th>Salary</th>
        <th>Action</th>
    </tr>

    <?php
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            echo "<tr>
                    <td>{$row['id']}</td>
                    <td>{$row['employee_id']}</td>
                    <td>{$row['employee_designation']}</td>
                    <td>{$row['employee_salary']}</td>
                    <td>
                        <form method='POST' action=''>
                            <input type='hidden' name='id' value='{$row['id']}'>
                            <input type='hidden' name='employee_id' value='{$row['employee_id']}'>
                            <input type='hidden' name='employee_designation' value='{$row['employee_designation']}'>
                            <input type='hidden' name='employee_salary' value='{$row['employee_salary']}'>
                            <button type='submit' name='edit'>Edit</button>
                        </form>
                    </td>
                  </tr>";
        }
    }
    ?>

</table>

</body>
</html>

<?php
$conn->close();
?>