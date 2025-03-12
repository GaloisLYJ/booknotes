import pymysql

conn = pymysql.connect(
    host='10.44.201.171',
    port=9030,
    user='ic_hrapi_mart',
    password='password',
    database='ic_hrapi_mart'
)
cursor = conn.cursor()

# 获取所有视图名称
cursor.execute("SHOW FULL TABLES WHERE Table_type = 'VIEW';")
views = cursor.fetchall()

# 检查每个视图定义
for view in views:
    view_name = view[0]
    cursor.execute(f"SHOW CREATE VIEW {view_name};")
    result = cursor.fetchone()
    create_view_statement = result[1]  # 视图定义在第二列
    param = 'ads_hr_coi_api8370_direct'
    if (param in create_view_statement.lower()):
        print(f"------------------start-------------------View {view_name} contains {param}.")
        print(f"{create_view_statement}")
        print(f"------------------end---------------------View {view_name} end");

conn.close()
