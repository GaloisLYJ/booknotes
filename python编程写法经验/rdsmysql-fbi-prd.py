import pymysql

conn = pymysql.connect(
    host='rm-qj87yrx9599kq2n15.mysql.rds.ops.cloud.byd.com',
    port=3306,
    user='fb',
    password='password',
    database='fbdb'
)
cursor = conn.cursor()
cursor.execute("SELECT ID,parentId,DISPLAYNAME FROM FINE_AUTHORITY_OBJECT WHERE parentId = 'decision-directory-root' order by sortIndex;")
menus = cursor.fetchall()

print(f"----BI自助分析 管理目录遍历 start----")
for t in menus:
    id = t[0]
    parent_id = t[1]
    display_name = t[2]
    cursor.execute("SELECT ID,parentId,DISPLAYNAME FROM FINE_AUTHORITY_OBJECT WHERE parentId = '"+ id +"' order by sortIndex;")
    menus2 = cursor.fetchall()
    for t2 in menus2:
        id2 = t2[0]
        parent_id2 = t2[1]
        display_name2 = t2[2]
        cursor.execute("SELECT ID,parentId,DISPLAYNAME FROM FINE_AUTHORITY_OBJECT WHERE parentId = '" + id2 + "' order by sortIndex;")
        menus3 = cursor.fetchall()
        for t3 in menus3:
            id3 = t3[0]
            parent_id3 = t3[1]
            display_name3 = t3[2]
            print(f"{display_name:<15}"+" "+f"{display_name2:<15}"+" "+f"{display_name3:<15}")
print(f"----BI 自助分析管理目录遍历 end----")
conn.close()
