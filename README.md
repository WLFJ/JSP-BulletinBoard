# JSP-JSP-BulletinBoard
一个简单的JSP留言板,实现了用户登陆控制、留言增删改查、搜索.
# Usage
1. Create Database:
```sql
-- 我们认为数据库是有的 现在创建表吧
DROP TABLE IF EXISTs posts;
DROP TABLE IF exists uzer;


-- 首先是用户表 需要用户ID 用户名 密码
CREATE TABLE uzer(
	userid INT primary key auto_increment,
	username TEXT not null,
	password TEXT not null
);

-- 发布文章的信息 需要文章ID 发布用户ID 标题 内容 时间
CREATE TABLE posts(
	postid INT primary key auto_increment,
	userid INT,
	title TEXT not null,
	post TEXT not null,
	postdate timestamp,
	foreign key(userid) references uzer(userid)
);

-- 下面是测试数据
INSERT INTO uzer(username, password) values('WLFJ', '1');
INSERT INTO posts(userid, title, post) values(1, '今日的洒脱', '自己喜欢的事情最开心');
```
2.Meke Connection
edit these two file respectively:`post.jsp` & `auth.jsp`
```java
conn = DriverManager.getConnection("jdbc:mysql://your_mysql_server/bulentinboard", "bbs_server", "pAsSwOrD");
```
3.Have fun :)
