import oracledb

# 指定客户端库路径 oracle连接需要客户端工具InstantClient
# https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html
# 添加到电脑系统环境变量path

# 显式打开厚模式
oracledb.init_oracle_client(lib_dir=r"D:\oracle\InstantClient\instantclient_23_7")

conn = oracledb.connect(
    user='bydhrcs',
    password='password',
    dsn='10.9.44.36:1521/ehr'
)

# 创建游标
cursor = conn.cursor()

# 查询
try:
    # BYD_SH_ADMIN_USER 普通管理员名单，BYD_SH_SYS_ROLE_REL_ADMIN 超管名单
    cursor.execute("select * from A001 where A001735 = :A001735", A001735='3625285')
    rows = cursor.fetchall()
    for row in rows:
        print(row)
except oracledb.DatabaseError as e:
    print(f"查询失败: {e}")

# 插入、更新
# try:
#     cursor.execute("INSERT INTO employees (id, name) VALUES (:1, :2)", (101, 'Alice'))
#     conn.commit()  # 提交事务
# except cx_Oracle.DatabaseError as e:
#     conn.rollback()  # 回滚事务
#     print(f"操作失败: {e}")

# 调用存储过程
# cursor.callproc('update_salary', [101, 5000])
# conn.commit()

# 关闭连接
cursor.close()
conn.close()




