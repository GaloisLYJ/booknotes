select * from MV_B001_ALL;

SELECT employee_id, employee_name, LEVEL
FROM employees
START WITH employee_id = 1
CONNECT BY PRIOR employee_id = manager_id;

WITH emp_hierarchy (employee_id, employee_name, level) AS (
  -- 锚定部分（根节点）
  SELECT employee_id, employee_name, 1 AS level
  FROM employees
  WHERE employee_id = 1
  UNION ALL
  -- 递归部分（子节点）
  SELECT e.employee_id, e.employee_name, eh.level + 1
  FROM employees e
  JOIN emp_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM emp_hierarchy;