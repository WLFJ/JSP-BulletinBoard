<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="WLFJ, and Bootstrap contributors">
<title>箴言·留言板</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css"
	integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
	crossorigin="anonymous">
<!-- Favicons -->
<link rel="apple-touch-icon"
	href="/docs/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
<link rel="icon" href="/docs/assets/img/favicons/favicon-32x32.png"
	sizes="32x32" type="image/png">
<link rel="icon" href="/docs/assets/img/favicons/favicon-16x16.png"
	sizes="16x16" type="image/png">
<link rel="manifest"
	href="https://v4.bootcss.com/docs/assets/img/favicons/manifest.json">
<link rel="mask-icon"
	href="/docs/assets/img/favicons/safari-pinned-tab.svg" color="#563d7c">
<link rel="icon" href="/docs/assets/img/favicons/favicon.ico">
<meta name="msapplication-config"
	content="https://v4.bootcss.com/docs/assets/img/favicons/browserconfig.xml">
<meta name="theme-color" content="#563d7c">


<style>
.bd-placeholder-img {
	font-size: 1.125rem;
	text-anchor: middle;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

@media ( min-width : 768px) {
	.bd-placeholder-img-lg {
		font-size: 3.5rem;
	}
}

.login-body {
	padding-top: 50px;
}

.form-signin {
	width: 100%;
	max-width: 330px;
	padding: 15px;
	margin: auto;
}

.form-signin .checkbox {
	font-weight: 400;
}

.form-signin .form-control {
	box-sizing: border-box;
	height: auto;
	padding: 10px;
	font-size: 16px;
}

.form-signin .form-control:focus {
	z-index: 2;
}


</style>
<!-- Custom styles for this template -->
<link href="album.css" rel="stylesheet">
</head>

<body>
<%!
	public abstract class SqlHelper{
		
		PreparedStatement pstsm = null;
		Connection conn = null;
	
		public ResultSet query(){
			ResultSet rs = null;
			try{
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://your_mysql_path", "bbs_server", "pAsSwOrD");
				rs = getResult(conn);
			}catch(ClassNotFoundException e){
				System.out.println("无法加载驱动");
			}catch(SQLException e){
				System.out.println("SQL执行错误");
			}
			
			return rs;
		}
		public abstract ResultSet getResult(Connection conn);
		public void closeDB(){
			try{
				if(pstsm != null) pstsm.close();
				if(conn != null) conn.close();
			}catch(SQLException e){
				
			}
		}
	}
%>
<%
	int user_id = -1;
	String user_name = null;
	if(session.getAttribute("user_id") != null){
		user_id = (int)session.getAttribute("user_id");
		user_name = (String)session.getAttribute("user_name");	
	}
	%>
	<%
	request.setCharacterEncoding("utf-8");
	//如果已经登陆 则直接跳到首页
	//首先看一下是否传入功能 logout login regist
	final String method = request.getParameter("method"), username = request.getParameter("username"), password1 = request.getParameter("password"), password2 = request.getParameter("password2");
	
	int status = 0;
	if(method != null){
		if(method.equals("logout")){
			//注销操作
			session.removeAttribute("user_name");
			session.removeAttribute("user_id");
			session.removeAttribute("flash_msg");
			response.sendRedirect("index.jsp");
			//之后显示登陆界面
		}else if(method.equals("login") && username != null && password1 != null){
			SqlHelper helper = new SqlHelper(){
				public ResultSet getResult(Connection conn){
					ResultSet re = null;
					try{
						pstsm = conn.prepareStatement("SELECT * FROM uzer WHERE username = ? AND password = ?;");
						pstsm.setString(1, username);
						pstsm.setString(2, password1);
						re = pstsm.executeQuery();
					}catch(Exception e){
						System.out.println("ERROR!");
					}
					return re;
				}
			};
			ResultSet res = helper.query();
			//现在我们可以检查是否符合条件了
			System.out.println(res == null);
			if(res.next()){//登陆成功
				session.setAttribute("user_id", res.getInt("userid"));
				session.setAttribute("user_name", res.getString("username"));
				response.sendRedirect("index.jsp");
			}else{
				session.setAttribute("flash_msg", "用户名与密码不匹配!");	
			}
			helper.closeDB();
		}else if(method.equals("regist")){
			status = 1;
			//注册界面同样也是这样的 只要参数不全 或者数据冲突就显示信息(因为可能有用户名和密码都相同的尴尬情况出现)
			if(username != null && password1 != null && password2 != null){
				if(!password1.equals(password2)){
					session.setAttribute("flash_msg", "两次密码不一致!");	
				}else{
					SqlHelper helper = new SqlHelper(){
						public ResultSet getResult(Connection conn){
							ResultSet re = null;
							try{
								pstsm = conn.prepareStatement("SELECT * FROM uzer WHERE username = ?");
								pstsm.setString(1, username);
								re = pstsm.executeQuery();
							}catch(Exception e){
								
							}
							return re;
						}
					};
					ResultSet res = helper.query();
					if(res != null && res.next()){
						//说明里面存在相同的用户了 注册失败
						session.setAttribute("flash_msg", "用户名已存在!");
					}else{
						//现在可以注册了
						new SqlHelper(){
							public ResultSet getResult(Connection conn){
								ResultSet re = null;
								try{
									pstsm = conn.prepareStatement("INSERT INTO uzer(username, password) VALUES(?, ?)");
									pstsm.setString(1, username);
									pstsm.setString(2, password1);
									pstsm.executeUpdate();
								}catch(Exception e){
									
								}
								closeDB();
								return null;
							}
						}.query();
						session.setAttribute("flash_msg", "注册成功!");
						//request.getRequestDispatcher("auth.jsp?method=login");
						response.sendRedirect("auth.jsp?method=login");
					}
					helper.closeDB();
				}
			}
		}
	}else{
		//没有指定则跳到首页
		response.sendRedirect("index.jsp");
	}
	
	%>
	<header>
		<div class="navbar navbar-dark fixed-top bg-dark shadow-sm">
			<div class="container d-flex justify-content-between">
				<a href="#" class="navbar-brand d-flex align-items-center"> <svg
						width="20" height="20" viewBox="0 0 16 16" fill="currentColor"
						class="mr-2" xmlns="http://www.w3.org/2000/svg">
		  <path fill-rule="evenodd"
							d="M14 1H2a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h2.5a2 2 0 0 1 1.6.8L8 14.333 9.9 11.8a2 2 0 0 1 1.6-.8H14a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"
							clip-rule="evenodd" />
		  <path
							d="M7.468 5.667c0 .92-.776 1.666-1.734 1.666S4 6.587 4 5.667C4 4.747 4.776 4 5.734 4s1.734.746 1.734 1.667z" />
		  <path fill-rule="evenodd"
							d="M6.157 4.936a.438.438 0 0 1-.56.293.413.413 0 0 1-.274-.527c.08-.23.23-.44.477-.546a.891.891 0 0 1 .698.014c.387.16.72.545.923.997.428.948.393 2.377-.942 3.706a.446.446 0 0 1-.612.01.405.405 0 0 1-.011-.59c1.093-1.087 1.058-2.158.77-2.794-.152-.336-.354-.514-.47-.563z"
							clip-rule="evenodd" />
		  <path
							d="M11.803 5.667c0 .92-.776 1.666-1.734 1.666-.957 0-1.734-.746-1.734-1.666 0-.92.777-1.667 1.734-1.667.958 0 1.734.746 1.734 1.667z" />
		  <path fill-rule="evenodd"
							d="M10.492 4.936a.438.438 0 0 1-.56.293.413.413 0 0 1-.274-.527c.08-.23.23-.44.477-.546a.891.891 0 0 1 .698.014c.387.16.72.545.924.997.428.948.392 2.377-.942 3.706a.446.446 0 0 1-.613.01.405.405 0 0 1-.011-.59c1.093-1.087 1.058-2.158.77-2.794-.152-.336-.354-.514-.469-.563z"
							clip-rule="evenodd" />
		</svg> <strong>箴言·留言板</strong>
				</a>
				
			</div>
		</div>
	</header>

	<main role="main" class="bg-light">

		<!-- 内容区域 -->

		<body class="login-body">
			<view style="padding:50px"></view>
			<view class="text-center">
				<form class="form-signin" method="post">
					<img class="mb-4"
						src="https://cdn.wlfj.fun/wp-content/uploads/2020/03/cropped-unnamed-192x192.jpg"
						alt="" width="72" height="72">
					<h1 class="h3 mb-3 font-weight-normal">实名上网,人人有责.</h1>
					<!-- 在这里添加告示 但是注意 如果使用重定向 则这里不应该将其删除 否则会出现问题 -->
					
					<%if(session.getAttribute("flash_msg") != null){ %>
					<div class="alert alert-danger alert-dismissable">
			            <button type="button" class="close" data-dismiss="alert"
			                    aria-hidden="true">
			                &times;
			            </button>
			            <%=session.getAttribute("flash_msg") %>
			        </div>
			        <%
			        if(response.getHeader("Location") == null){//通过头来判断是否需要删除消息
			        	session.removeAttribute("flash_msg");
			        }
					} %>
					<input type="text" name="method" value="login" class="sr-only">
					<label for="inputUserName" class="sr-only">用户名</label>
					<input type="text" id="inputUserName" class="form-control mb-3" placeholder="用户名" name="username" required autofocus>
					<label for="inputPassword" class="sr-only">密码</label>
					<input type="password" id="inputPassword" class="form-control mb-3" placeholder="密码" name="password" required>
					<%if(status == 1){//需要注册 %>
					<label for="inputPassword2" class="sr-only">确认密码</label>
					<input type="password" id="inputPassword2" class="form-control mb-3" placeholder="确认密码" name="password2" required>
					<%} %>
					<%if(status == 0){ %>
					<p></p>
					<p class="text-right">没有账号?<a href="auth.jsp?method=regist">点我注册</a></p>
					<%} %>
					</div>
					<button class="btn btn-lg btn-primary btn-block" type="submit"><%=(status == 1 ? "注册" : "登陆")%></button>
					<div class="mb-5">
				</form>
			</view>

		</body>

	</main>

	<footer class="text-muted">
		<!-- 底部区域 -->
		<div class="container">
			<p class="float-right">
				<a href="#">返回顶部</a>
			</p>
			<p>2020 @WLFJ 谁知晚来风急</p>
			<p>
				生命分毫之间,思想在闪烁.有关我生活的一隅,访问 <a href="https://wlfj.fun/">我的博客</a>.
			</p>
		</div>
	</footer>
	<script
		src="https://cdn.jsdelivr.net/npm/jquery@3.4.1/dist/jquery.slim.min.js"
		integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
		integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js"
		integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
		crossorigin="anonymous"></script>
</html>
