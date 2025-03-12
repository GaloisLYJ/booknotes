import psycopg2

# 连接参数配置
conn_params = {
    "host": "10.0.75.240",
    "port": "5432",
    "database": "ihr",
    "user": "ehr_developer",
    "password": "password"
}

try:
    # 建立数据库连接
    conn = psycopg2.connect(**conn_params)
    cursor = conn.cursor()

    # 执行测试查询
    cursor.execute("SELECT version();")
    db_version = cursor.fetchone()
    print("PostgreSQL版本信息:", db_version)

except Exception as e:
    print("连接异常:", e)

finally:
    # 关闭连接
    if 'conn' in locals():
        cursor.close()
        conn.close()
